
(* A *)
 fun zip ([],[])=[]
| zip (x::xs,y::ys)=(x,y)::zip(xs,ys) 
| zip (_,_)=[];


(* B *)
fun unzip [] = ([],[])
| unzip ((x1,y1)::l) = 
	let val (xs,ys) = unzip l in (x1::xs,y1::ys) end;

(* C *)
fun flatten []=[]
| flatten (x::l)=x@flatten l;


(* D *)
exception EndOfList;
exception NegativeIndex;

fun mynth _ []=raise EndOfList
|	mynth 0 (y::ys) = y
|	mynth x (y::ys) = if x<0 then raise NegativeIndex else mynth (x-1) ys; 



(* E *)
exception NotFound;
type 'a env = (string*'a) list;
val emptyEnv=[]:'a env;
fun bindVar(name,x,E)=(name,x)::E:'a env;

fun isBound(name,[]) = false
|	isBound(name,(s,e)::E)= if s=name then true else isBound(name,E);

fun lookup(name,[]) = raise NotFound
|	lookup(name,(s,e)::E)= if s=name then e else lookup(name,E);




(* F *)
exception NotFound;
type 'a fenv = string -> 'a;
fun femptyEnv(name:string)=raise NotFound;
fun fbindVar (name:string,x,E) = fn nm => if nm=name then x else E nm; 
fun flookup (name, rho) = rho name;
fun fisBound(name,E)=let val m=flookup(name,E) in true end handle NotFound => false;


(* G *)

exception Screwed;
datatype 'a seq=Empty
| singleton of 'a
| sequence of 'a seq*'a seq;

fun scons(f,s)=sequence(singleton(f),s);
fun ssnoc(f,s)=sequence(s,singleton(f));
fun sappend(s1,s2)=sequence(s1,s2);
fun listOfSeq(singleton(a))=a::nil
|	listOfSeq(Empty)=nil
|	listOfSeq(sequence(a,b))=listOfSeq(a)@listOfSeq(b);

fun seqOfList [] = Empty
| seqOfList (x::nil) = singleton(x)
| seqOfList (x::xs) = sequence(singleton(x), seqOfList(xs));





(* H *)
(* My idea for this is to have two sequences one for values left of the finger, one for the right of the finger and a value at the finger.
Something like a ('a seq * 'a * 'a seq) tuple..   The thing that royally hosed me is finding a pattern that will let me peel the first or last element off a sequence.  Without that go and delete are f'ed.

- singletonOf would be a value at the finger with empty sequences left and right.

- atFinger just returns the finger

- goLeft would create a new flist, cons'ing the exisitng finger to the sequence on the right, and decomposing the sequence on the left to get the last element, which becomes the new finger.

- deleteLeft would create a new flist with the same finger and right sequence, but would trim off the last element of the left sequence.

- deleteRight would create a new flist with the same finger and left sequence, but would trim off the first element of the right sequence.

- insertLeft would create a new flist with the same finger and right sequence, but would "ssnoc" the value onto the end of the left sequence.

- insertRight would create a new flist with the same finger and left sequence, but would "scons" the value onto the front of the right sequence.

*)


type 'a flist='a seq * 'a * 'a seq;
fun singletonOf x = (Empty,x,Empty):'a flist;
fun atFinger(F:'a flist)=let val (a,b,c)=F in b end;
fun insertLeft(x,F)=let val (l,f,r)=F in (ssnoc(x,l),f,r) end;
fun insertRight(x,F)=let val (l,f,r)=F in (l,f,scons(x,r)) end;


(*  these don't work, but I hope they show I had a plan
fun goLeft(F)=let val (l,f,r)=F in let val (sequence(a,singleton(b)))=l in (a,b,scons(f,r)) end end;
fun goRight(F)=let val (l,f,r)=F in let (sequence(singleton(a),b))=r in (ssnoc(f,l),a,b) end end;
fun deleteLeft(F)=let val (l,f,r) in let (sequence(a,singleton(b)))=l in (a,f,r) end end;
fun deleteRight(F)=let val (l,f,r) in let (sequence(singleton(a),b))=l in (l,f,b) end end;

*)