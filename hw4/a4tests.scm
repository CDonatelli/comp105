;; ------------------------------------------------------------
;; Test script for assignment 4
;;
;; To use this script:
;;    cat solution.scm a4tests.scm | uscheme -q
;;
;; This file contains a series of tests for assignment 4 -- one
;; for each function. I encourage you to add more. Each test 
;; calls the given function and compares the result with the
;; expected result using 'equal?'. In addition, there are a couple
;; of tests that check the algebraic identities.
;;
;; Rather than print a message, each exercise starts with an
;; empty 'define' that causes the interpreter to print that
;; name. Each test results in either #t or #f. So, a successful
;; test should print each function name and a series of #t's (with
;; no other interpreter errors)

;; 2.a
(define COUNT-TEST () 0)
(equal? (count 1 '(3 2 1 7 1)) 2)       ;; 2
(equal? (count 'a '(a b a c (c a) a d)) 3)
(equal? (count '() '(a  () b a c (c () a) a d)) 1)


;; 2.b
(define COUNTALL-TEST () 0)
(equal? (countall 1 '(3 2 1 7 1)) 2)       ;; 2
(equal? (countall 'a '(a b a c (c a) a d)) 4)
(equal? (countall 'c '(a b (a c) (c a (a c ((a c)(a)))) a d)) 4)
(equal? (countall '() '(a  () b a c (c () a) a d)) 2)

;; 2.c
(define MIRROR-TEST () 0)
(equal? (mirror '((1 2) (3 4 5))) '((5 4 3) (2 1)))
(equal? (mirror '(1 2 3)) '(3 2 1))
(equal? (mirror '((a (b 5)) (c d) e)) '(e (d c) ((5 b) a)))
(equal? (mirror '((1 (2 3))(4 (5 (6 7)))(8 (9 (10 11 12 13))))) '((((13 12 11 10) 9 ) 8) (((7 6) 5) 4)((3 2) 1))) 

;; 2.d
(define FLATTEN-TEST () 0)
(equal? (flatten '((1 2) (3 4 5))) '(1 2 3 4 5))
(equal? (flatten '((1 (2 3))(4 (5 (6 7)))(8 (9 (10 () 11 12 13))))) '(1 2 3 4 5 6 7 8 9 10 11 12 13))
;; 2.e
(define CONTIG-SUBLIST?-TEST () 0)
(equal? (contig-sublist? '(a b c) '(x a y b z c)) #f)
(equal? (contig-sublist? '(a y b) '(x a y b z c)) #t)

;; 2.f
(define SUBLIST?-TEST () 0)
(equal? (sublist? '(a b c) '(x a y b z c)) #t)
(equal? (sublist? '(a z b) '(x a y b z c)) #f)

;; 9.a
(define CDR*-TEST () 0)
(equal? (cdr* '((a b c) (d e))) '((b c) (e)))

;; 9.b
(define MAX*-TEST () 0)
(equal? (max* '(1200 3 1199)) 1200)

;; 9.g
(define APPEND-TEST () 0)
(equal? (append-hof '(1) '(2 3)) '(1 2 3))

;; 9.i
(define REVERSE-TEST () 0)
(equal? (reverse-hof '(1 2 3 4 5)) '(5 4 3 2 1))

;; take
(define TAKE-TEST () 0)
(equal? (take 2 '(1 2 3 4 5)) '(1 2))

;; drop
(define DROP-TEST () 0)
(equal? (drop 2 '(1 2 3 4 5)) '(3 4 5))

;; take drop law
(equal? (append (take 3 '(1 2 3 4 5)) (drop 3 '(1 2 3 4 5))) '(1 2 3 4 5))

;; zip
(define ZIP-TEST () 0)
(equal? (zip '(1 2 3) '(a b c)) '((1 a) (2 b) (3 c)))

;;unzip
(define UNZIP-TEST () 0)
(equal? (unzip'((I Magnin) (U Thant) (E Coli))) '((I U E) (Magnin Thant Coli)))

;; algebraic laws
(val pairlist '((I Magnin) (U Thant) (E Coli)))
(equal? pairlist (zip (car (unzip pairlist)) (cadr (unzip pairlist))))

;; arg-max
(define ARG-MAX-TEST () 0)
(define square (a) (* a a))
(equal? 5 (arg-max square '(5 4 3 2 1)))

;; merge
(define MERGE-TEST () 0)
(equal? (merge '(1 3 5) '(2 4 6)) '(1 2 3 4 5 6))

;; interleave
(define INTERLEAVE-TEST ()  0)
(equal? (interleave '(1 2 3) '(a b c)) '(1 a 2 b 3 c))

;; Tree test
(define EVAL-TEST () 0)
(equal? (evalexp '((2 * 5) + 10)) 20)

(define TO-PREFIX-TEST() 0)
(equal? (to-prefix '((2 * 5) + 10)) '(+ (* 2 5) 10))
