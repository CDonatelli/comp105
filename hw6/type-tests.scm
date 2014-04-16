(val e1 (type-lambda ('a 'b) (lambda (('a x)('b y)) x)))
; type is: (forall ('a 'b) (function ('a 'b) 'a))

(val e2 (@ '() int))
; type is: (list int)

(val e3 '(#f 1))
; type error: LITERAL - PAIR - mismatch

(val e4 (while #f (+ 1 1)))
; type is: unit

(val e5 (if ((@ = int) 4 4) 5 6))
; type is: int


