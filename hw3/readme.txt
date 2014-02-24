Ian  Altgilbers (ialtig01)
Partner - Paul Nixon

Strategy - 
I was considering creating a new environment "locals" to hold the local variables, this would've required changing the definition of eval and every place eval was called.  After consultation, my partner opened my eyes to the fact that the locals can live the the same environment as the formals.   So, we just added all the locals to the formals environment, setting values to 0.  If there is a naming conflict, the locals trump the formals (the value of the formal is lost, but it is of no use so this is ok).

I didn't discuss this assignment with anyone other than my partner.

I spent a couple hours by myself reading over the code and reading through section 2.5 in the text book.   We spent about an hour or so together poking at the solution.


