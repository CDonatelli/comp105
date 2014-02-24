;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define count (x xs)
	(if (null? xs)
		0
		(if (equal? x (car xs))
			(+ 1 (count x (cdr xs)))
			(count x (cdr xs)))))

;(count 'a '(a b a c (c a) a d))
;(count '() '(a  () b a c (c () a) a d))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define countall (x xs)
	(if (null? xs)
		0
		(if (pair? (car xs))
			(+ (countall x (car xs)) (countall x (cdr xs)))
			(if (equal? x (car xs))
				(+ 1 (countall x (cdr xs)))
				(countall x (cdr xs))))))
			
;(countall 'a '(a b a c (c a) a d))
;(countall 'c '(a b (a c) (c a (a c ((a c)(a)))) a d))
;(countall '() '(a  () b a c (c () a) a d))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1c
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define mirror (xs)
	(if (null? xs)
		xs
		(if (pair? xs)
			(append (mirror (cdr xs)) (list1 (mirror (car xs))))
			xs)))

;(mirror '(1 2 3))
;(mirror '((a (b 5)) (c d) e))
;(mirror '((1 (2 3))(4 (5 (6 7)))(8 (9 (10 11 12 13)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1d   ---   consider lists with embedded empty lists...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define flatten (xs)
	(if (null? xs)
		xs
		(if (atom? xs)
			(list1 xs)
			(append (flatten (car xs)) (flatten (cdr xs))))))

;(flatten '((a (b 5)) (c d) e))
;(flatten '((1 (2 3))(4 (5 (6 7)))(8 (9 (10 () 11 12 13)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1e
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define contig-sublist-helper (orig xs ys)
	(if (null? xs)									;if xs is null, we match
		#t
		(if (null? ys)								;if ys is null, no match
			#f
			(if (equal? (car xs) (car ys))
				(contig-sublist-helper orig (cdr xs) (cdr ys))
				(contig-sublist-helper orig orig (cdr ys))))))

(define contig-sublist? (xs ys)
	(contig-sublist-helper xs xs ys))


;(contig-sublist? '(a y b) '(x a y b z c))
;(contig-sublist? '(a b c) '(x a y b z c))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1f
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define sublist? (xs ys)
	(if (null? xs)
		#t
		(if (null? ys)
			#f
			(if (equal? (car xs) (car ys))
				(sublist? (cdr xs) (cdr ys))
				(sublist? xs (cdr ys))))))

;(sublist? '(a b) '(a b c))
;(sublist? '(a b) '(b b b c))
;(sublist? '(a y b) '(x a y b z c))
;(sublist? '(a b c) '(x a y b z c))
;(sublist? '(c b a) '(x a y b z c))









;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;9a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define cdr* (lists)
	(map cdr lists))


;(cdr* '((a b c) (d e) (f)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;9b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define max* (xs)
	(foldr (lambda (x y) (if (> x y) x y)) (car xs) xs))	

;(max '(1 2 3 4 5 2 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;9g
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define append-hof (xs ys)
	(foldr cons ys xs))

;(append-hof '(1 2 3) '(4 5 6))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;9i
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define reverse-hof (xs)
	(foldl cons '() xs))

;(reverse-hof '(6 5 4 3 2 1))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;A. Take and drop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define take (n xs)
	(if (null? xs)
		xs
		(if (equal? n 0)
			'()
			(cons (car xs)(take (- n 1) (cdr xs))))))
;(take 4 '(1 2 3 4 5 6))


(define drop (n xs)
	(if (null? xs)
		xs
		(if (equal? n 0)
			xs
			(drop (- n 1) (cdr xs)))))
;(drop 3 '(1 2 3 4 5))

;(append (take 4 '(1 2 3 4 5 6)) (drop 4 '(1 2 3 4 5 6)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; B. Zip and unzip
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define zip (xs ys)
	(if (null? xs)
		xs
		(cons (list2 (car xs) (car ys)) (zip (cdr xs) (cdr ys)))))

;(zip '(a b c) '(1 2 3))

	
(define unzip (xs)
	(if (null? xs)
		xs
		(list2 (map car xs) (map cadr xs))))

;(unzip '((I Magnin) (U Thant) (E Coli)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;C. Arg max
;  - build list of pairs...  with the value and the operated value..
;  then fold across the list, picking out the max value...  return
; the other half of the list..
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(define greater (x y) (if (> x y) x y))
;(define max (xs)
;	(foldr greater (car xs) xs))	

;(define max (xs)
;	(foldr (lambda (x y) (if (> x y) x y)) (car xs) xs))	

;(max '(1 2 3 4 5 2 1))


;(define arg-max (f A)
;	(max (map f A)))
;(define square (a) (* a a))
;(arg-max square '(5 4 3 2 1));




;(define operate (f xs)
;	(zip xs (map f xs)))

(define arg-max (f A)
	(car (foldr (lambda (x y) (if (> (cadr x) (cadr y)) x y)) (car (zip A (map f A))) (zip A (map f A)))))






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;D. Merging sorted lists
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define merge (xs ys)
	(if (null? xs)
		ys
		(if (null? ys)
			xs
			(if (< (car xs) (car ys))
				(cons (car xs) (merge (cdr xs) ys))	
				(cons (car ys) (merge xs (cdr ys)))))))
;(merge '(1 3 5) '(2 4 6))	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;E. Interleaving lists
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define interleave (xs ys)
	(if (null? xs)
		(if (null? ys)
			ys
			(interleave ys xs))
		(cons (car xs) (interleave ys (cdr xs)))))

;(interleave '(1 2 3) '(a b c))	
;(interleave '(1 2 3) '(a b c d e f))
;(interleave '(a b c d e f) '(1 2 3))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;F. Working with trees
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define to-prefix (xs)
	(if (pair? (car xs))
		(if (pair? (caddr xs))
			(list3 (cadr xs) (to-prefix (car xs)) (to-prefix (caddr xs)))
			(list3 (cadr xs) (to-prefix (car xs)) (caddr xs)))
		(list3 (cadr xs) (car xs) (caddr xs))))

(to-prefix '((1 + 2) * (12 / 4)))			




(define eval (xs)
	(if (number? xs)
		xs
		(if (equal? (car xs) '+)
			(+ (eval (cadr xs)) (eval (caddr xs)))
			(if (equal? (car xs) '-)
				(- (eval (cadr xs)) (eval (caddr xs)))
				(if (equal? (car xs) '*)
					(* (eval (cadr xs)) (eval (caddr xs)))
					(if (equal? (car xs) '/)
						(/ (eval (cadr xs)) (eval (caddr xs)))
						(error 'malformed)))))))

(define evalexp (xs)
	(eval (to-prefix xs)))

;(evalexp '((1 + 2) * (12 / 4)))			




