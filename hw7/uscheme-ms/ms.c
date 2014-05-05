/*
 * Prototype mark-and-sweep allocator for micro-Scheme
 * 
 * We present code for a prototype allocator; the
 * Exercises explain how to extend this allocator into a
 * full mark-and-sweep system.
 * <ms.c>=
 */
#include "all.h"

/*
 * A mark-and-sweep collector needs to associate a mark
 * bit with each heap location. For simplicity, we make
 * no attempt to pack mark bits densely; we simply wrap
 * each [[Value]] in another structure, which holds a
 * single mark bit, [[live]]. By placing the [[Value]]
 * at the beginning, we ensure that it is safe to cast
 * between values of type [[Value*]] and type
 * [[Mvalue*]].
 * <private declarations for mark-and-sweep collection>=
 */
typedef struct Mvalue Mvalue;
struct Mvalue {
				Value v;
				unsigned live:1;
};
/*
 * We put these wrapped values into arenas. A single
 * arena holds a contiguous array of objects; the entire
 * heap is formed by chaining arenas into linked lists.
 * The arena is the unit of heap growth; when the heap
 * is too small, we call [[malloc]] to add one or more
 * arenas to the heap.
 * <private declarations for mark-and-sweep collection>=
 */
enum growth_unit { GROWTH_UNIT = 24 };
typedef struct Arena *Arena;
struct Arena {
				Mvalue pool[GROWTH_UNIT];
				Arena tl;
};
/*
 * We use the [[tl]] field to chain arenas on a linked
 * list; the head of that list is called [[arenalist]].
 * The ``heap pointer'' [[hp]] points to the next
 * [[Mvalue]] to be allocated. The pointer [[heaplimit]]
 * points to the first [[Mvalue]] after the current
 * arena, [[curarena]].
 * <private declarations for mark-and-sweep collection>=
 */
Arena arenalist, curarena;
Mvalue *hp, *heaplimit;
/*
 * The search itself is straightforward; there is one
 * procedure for each type of object to be visited.
 * Function [[visitroot]] looks at the tag of a root and
 * calls the appropriate visiting procedure.
 * <private declarations for mark-and-sweep collection>=
 */
static void visitheaploc      (Value *loc);
static void visitstackvalue   (Value v);
static void visitvaluechildren(Value v);
static void visitenv          (Env env);
static void visitvaluelist    (Valuelist vl);
static void visitexp          (Exp exp);
static void visitexplist      (Explist el);
static void visitdef          (Def def);
static void visitroot         (Root r);
/*
 * <private declarations for mark-and-sweep collection>=
 */
static int nalloc;              /* total number of allocations */
static int ncollections;        /* total number of collections */
static int nmarks;              /* total number of cells marked */
/*
 * The function [[makecurrent]] makes [[curarena]],
 * [[hp]], and [[heaplimit]] point to an arena from
 * which no locations have yet been allocated.
 * <ms.c>=
 */
static void makecurrent(Arena a) {
				assert(a != NULL);
				curarena = a;
				hp = &a->pool[0];
				heaplimit = &a->pool[GROWTH_UNIT];
}
/*
 * When the heap grows, it grows by one arena at a time.
 * We allocate new arenas with [[calloc]] so that the
 * mark bits are zeroed. It is a checked run-time error
 * to call [[addarena]] except when [[arenalist]] is
 * [[NULL]] or when [[curarena]] points to the last
 * arena in the list.
 * <ms.c>=
 */
static int heapsize;            /* OMIT */
static void addarena(void) {
				Arena a = calloc(1, sizeof(*a));
				assert(a != NULL);

				if (arenalist == NULL) {
								arenalist = a;
				} else {
								assert(curarena != NULL && curarena->tl == NULL);
								curarena->tl = a;
				}
				makecurrent(a);
				heapsize += GROWTH_UNIT;   /* OMIT */
}
/*
 * We provide a prototype allocator that never collects
 * garbage; when it runs out of space, it just adds a
 * new arena. Exercise [->] discusses how to replace
 * this allocator with one that supports garbage
 * collection. [*]
 * <ms.c ((prototype))>=
 */

void printheap();
void mark(void)
{
				int i,tmp_nmarks;
				ncollections++;
				tmp_nmarks=nmarks;
				for(i=0;i<rootstacksize;i++)
				{
								visitroot(rootstack[i]);
				}
				fprintf(stderr,"Collection #%d\theapsize:%d\tlive:%d\tratio:%f\n",ncollections,heapsize,nmarks-tmp_nmarks,(float)heapsize/(nmarks-tmp_nmarks));
				if(ncollections%10==0)
				{
								fprintf(stderr,"After %d collections\tallocations: %d\theap size: %d\tmarks:%d\n",ncollections,nalloc,heapsize,nmarks);
				}
}


void printheap()
{
				int i,j;
				char w;
				Arena a;
				j=0;
				a=arenalist;
				fprintf(stderr,"\nGarbage collection stats:\n");
				fprintf(stderr,"%d - cumulative allocations\n",nalloc);
				fprintf(stderr,"%d - cumulative collections\n",ncollections);
				fprintf(stderr,"%d - cumulative marks\n",nmarks);
				fprintf(stderr,"State of the heap... '0' is unmarked, '1' is marked, 'x' is location of hp.\n");
				while(1)
				{
								if(a==NULL)
												return;
								fprintf(stderr,"arena\t%d:\t",j);
								for(i=0;i<GROWTH_UNIT;i++)
								{
												if(hp==&a->pool[i])
																	w='x';
												else if (a->pool[i].live==1)
																w='1';
												else
																w='0';
												fprintf(stderr,"%c",w);
								}
								fprintf(stderr,"\n");
								j++;
								if(a->tl == NULL)
												return;
								else
												a=a->tl;
				}
}

/*
	 For each allocloc, we start with the heap pointer where it was last left..

	 1. Check to see if the current location is marked, if it is, then unmark it and move the pointer and start over.
	 2. If the MValue at hp is not marked, return it (incrementing hp)
	 3. If hp == heaplimit, then we mark.
	 4. If we mark and are still unable to allocate, then we grow the heap.
 */

Value* allocloc_helper(void)
{
				if(curarena==NULL)
								return NULL;
				while(1)
				{
								while(hp<heaplimit)   /* while we're not a the end of the arena */
								{
												if (!hp->live)  /* if hp->live is zero */
												{
																assert(hp < heaplimit);
																return &(hp++)->v;
												}
												else /* if the current hp is marked live, unmark it and check the next */
												{
																/*								fprintf(stderr,"unmarking slot %ld...\n",heaplimit-hp);  */
																hp->live=0;
																hp++;
												}
								}
								/* at the end of this arena, let's move to the next */
								if(curarena->tl==NULL)
												return NULL;
								else
												makecurrent(curarena->tl);
				}
}

Value* allocloc(void) {
				/* always increment nalloc for every allocation */
				Value *V;
				int tempmarks;
				nalloc++;	
				/*  call allocloc_helper to get a pointer to the next empty cell */
				V=allocloc_helper();

				/* if we get nothing, we call mark, then reset our pointer to the beginning of the heap */
				if(V!=NULL)
				{
								return V;
				}
				else
				{
								/* fprintf(stderr,"calling mark and resetting hp to beginning of arenalist\n"); */
								/*printheap();*/
								tempmarks=nmarks;
								mark();
								if(tempmarks==nmarks)
								{
												/*fprintf(stderr,"nothing new was marked...\n");*/
								}
								/*printheap();*/
								if(arenalist!=NULL)
								{
												makecurrent(arenalist);
								}
								else
								{
								/*				fprintf(stderr,"arenalist is NULL, so this must be the first alloc");  */
								}
				}

				/* after marking, we try again..  If there's still no empty cells, we add a new arena, growing the heap. */
				V=allocloc_helper();
				if(V!=NULL)
				{
								return V;
				}
				else
				{
								/*fprintf(stderr,"Exhausted current heap, adding an arena...\n");*/
								addarena();
								return &(hp++)->v;
				}
}
/*
 * Writing these procedures is mostly straightforward.
 * Here, for example, is the code to visit an [[Env]]
 * node.
 * <ms.c>=
 */
static void visitenv(Env env) {
				for (; env; env = env->tl)
								visitheaploc(env->loc);
}
/*
 * In order for this function to work, we have to expose
 * the representation of environments. In Chapter [->],
 * this representation is private.
 */

/*
 * The most subtle aspect of the visiting functions is
 * that they must distinguish values allocated on the
 * heap from those allocated on the stack. A
 * heap-allocated value is embedded inside an [[Mvalue]]
 * and has a mark bit, but a stack-allocated value is
 * not in an [[Mvalue]] and has no mark bit. For both
 * kinds of values, we need to visit the children, but
 * only for a heap-allocated value do we set a mark bit.
 * <ms.c ((prototype))>=
 */
static void visitheaploc(Value *loc) {
				Mvalue *m = (Mvalue*)loc;
				if (!m->live) {
								m->live = 1;
								nmarks++;
								visitvaluechildren(m->v);
				}
}
/*
 * <ms.c>=
 */
static void visitstackvalue(Value v) {
				visitvaluechildren(v);
}
/*
 * Function [[visitvaluechildren]] works the same
 * whether a value is allocated on the stack or the
 * heap.
 * <ms.c>=
 */
static void visitvaluechildren(Value v) {
				switch (v.alt) {
								case NIL:
								case BOOL:
								case NUM:
								case SYM:
								case PRIMITIVE:
												return;
								case PAIR:
												visitheaploc(v.u.pair.car);
												visitheaploc(v.u.pair.cdr);
												return;
								case CLOSURE:
												visitexp(v.u.closure.lambda.body);
												visitenv(v.u.closure.env);
												return;
								default:
												assert(0);
												return;
				}
}
/*
 * To visit an expression, we visit its literal value,
 * if any, and of course its subexpressions.
 * <ms.c>=
 */
static void visitexp(Exp e) {
				switch (e->alt) {
								case LITERAL:
												visitvaluechildren(e->u.literal);
												return;
								case VAR:
												return;
								case IFX:
												visitexp(e->u.ifx.cond);
												visitexp(e->u.ifx.true);
												visitexp(e->u.ifx.false);
												return;
								case WHILEX:
												visitexp(e->u.whilex.cond);
												visitexp(e->u.whilex.body);
												return;
								case BEGIN:
												visitexplist(e->u.begin);
												return;
								case SET:
												visitexp(e->u.set.exp);
												return;
								case LETX:
												visitexplist(e->u.letx.el);
												visitexp(e->u.letx.body);
												return;
								case LAMBDAX:
												visitexp(e->u.lambdax.body);
												return;
								case APPLY:
												visitexp(e->u.apply.fn);
												visitexplist(e->u.apply.actuals);
												return;
								default:
												assert(0);
				}
}
/*
 * To visit a definition, we visit any expressions it
 * contains.
 * <ms.c>=
 */
				static void visitdef(Def d) {
								if (d == NULL)
												return;
								else
												switch (d->alt) {
																case VAL:
																				visitexp(d->u.val.exp);
																				return;
																case EXP:
																				visitexp(d->u.exp);
																				return;
																case DEFINE:
																				visitexp(d->u.define.lambda.body);
																				return;
																case USE:
																				return;
																default:
																				assert(0);
												}
				}
/*
 * To visit a root, we call the appropriate visiting
 * procedure.
 * <ms.c>=
 */
static void visitroot(Root r) {
				switch (r.alt) {
								case STACKVALUEROOT:
												visitstackvalue(*r.u.stackvalueroot);
												return;
								case HEAPLOCROOT:
												visitheaploc(*r.u.heaplocroot);
												return;
								case ENVROOT:
												visitenv(*r.u.envroot);
												return;
								case EXPROOT:
												visitexp(*r.u.exproot);
												return;
								case VALUELISTROOT:
												visitvaluelist(*r.u.valuelistroot);
												return;
								case DEFROOT:
												visitdef(*r.u.defroot);
												return;
								default:
												assert(0);
				}
}
/*
 * Here are procedures for visiting various lists.
 * <ms.c>=
 */
static void visitvaluelist(Valuelist vl) {
				for (; vl; vl = vl->tl)
								visitvaluechildren(vl->hd);
}
/*
 * <ms.c>=
 */
static void visitexplist(Explist el) {
				for (; el; el = el->tl)
								visitexp(el->hd);
}
/*
 * <ms.c ((prototype))>=
 */
/* you need to redefine these functions */
void printfinalstats(void) { 
				(void)nalloc; (void)ncollections; (void)nmarks;
				fprintf(stderr,"\nGarbage collection stats:\n");
				fprintf(stderr,"%d - allocations\n",nalloc);
				fprintf(stderr,"%d - collections\n",ncollections);
				fprintf(stderr,"%d - mark\n",nmarks);
				assert(1); 
}
/*
 * Completed garbage collectors
 * 
 * [Table of contents]
 * 
 * [*]
 * 
 * Mark and sweep
 * 
 * These variables help us accumulate statistical
 * information; they are totals for the lifetime of the
 * program.
 */

