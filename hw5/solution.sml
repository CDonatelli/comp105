(* A *)
 fun zip ([],[])=[]
| zip (x::xs,y::ys)=(x,y)::zip(xs,ys) 
| zip (_,_)=[];

(* B *)
fun unzip [] = ([],[])
| unzip ((x1,y1)::l) = 
	let val (xs,ys) = unzip l in (x1::xs,y1::ys) end;
val xyz = [(1, true), (3, false)];
unzip xyz;

(* C *)
fun flatten []=[]
| flatten (x::l)=x@flatten l;

flatten [[1], [2, 3, 4], [], [5, 6]];

(* D *)
exception EndOfList;
exception NegativeIndex;

fun mynth _ []=raise EndOfList
|	mynth 0 (y::ys) = y
|	mynth x (y::ys) = if x<0 then raise NegativeIndex else mynth (x-1) ys; 

mynth 3 [0,1,2,3];
mynth ~3 [0,1];
mynth 5 [0,1,2,3];


(* E *)
type 'a env = (string*'a) list;
val emptyEnv=[]:'a env;
fun bindVar(name,x,E)=(name,x)::E:'a env;

fun isBound(name,[]) = false
|	isBound(name,(s,e)::E)= if s=name then true else isBound(name,E);

exception NotFound;
fun lookup(name,[]) = raise NotFound
|	lookup(name,(s,e)::E)= if s=name then e else lookup(name,E);



(* F *)
type 'a fenv = string -> 'a;
val femptyEnv=[]:'a fenv;
fun fbindVar(name,x,E)=if name=

fun flookup (name, rho) = rho name;

(* G *)
exception Screwed;
datatype 'a seq=Empty
| singleton of 'a
| sequence of 'a seq*'a seq;

fun scons(f,s)=sequence(singleton(f),s);
fun ssnoc(f,s)=sequence(s,singleton(f));
fun sappend(s1,s2)=sequence(s1,s2);
fun listofSeq(singleton(a))=a::nil
|	listofSeq(Empty)=nil
|	listofSeq(sequence(a,b))=listofSeq(a)@listofSeq(b);


val x1=singleton(1);
val s1=sequence(x1,Empty);
val s2=sequence(s1,s1);
val s3=ssnoc(3,s2);
val s4=scons(4,s3);
listofSeq(s1);
listofSeq(s2);
listofSeq(s3);
listofSeq(s4);


(* H *)
(* My idea for this is to have two sequences one for values left of the finger, one for the right of the finger and a value at the finger.
Something like a ('a seq * 'a * 'a seq) tuple..   
If I had my sequence code working,  I might be able to finish this part...

- singletonOf would be a value at the finger with empty sequences left and right.

- goLeft would create a new flist, cons'ing the exisitng finger to the sequence on the right, and decomposing the sequence on the left to get the last element, which becomes the new finger.

- deleteLeft would create a new flist with the same finger and right sequence, but would trim off the last element of the left sequence.

- insertLeft would create a new flist with the same finger and right sequence, but would "ssnoc" the value onto the end of the left sequence.

*)

type 'a flist='a seq * 'a * 'a seq;


fun singletonOf x = (Empty,x,Empty):'a flist;

