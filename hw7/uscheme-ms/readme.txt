
HW7 - garbage collector in uscheme

Partner - none

Consultation - I discussed the assignment in general terms with a few classmates after structured office hours... I don't know their names, but we talked about the seeming lack of a need for the "grow heap" function, and the format of the output

Time spent - a couple hours before the starter code was updated, then probably 4 hours to get most of the way, and then a few more hours trying to add instrumentation to monitor the heap.  My source has a "printheap" function that you can invoke by entering '%' on the uscheme command line.  It shows the current heap state, with cells being 0, 1, or x (x being the current heap pointer location).

I made very minor changes to all.h, just adding a function declaration for
printheap(), and to lex.c too allow me to call printheap() when % is entered.


