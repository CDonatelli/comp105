;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 1a  -  there are a bunch of ways to do this one...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(define count (x xs)
;	(if (null? xs)
;		0
;		(if (equal? x (car xs))
;			(+ 1 (count x (cdr xs)))
;			(count x (cdr xs)))))

;;; curry "=" with x, filter the list with the resulting predicate, then count remaining elements
(define count (x xs)
	(length (filter ((curry =) x) xs)))

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
			

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1c
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define mirror (xs)
	(if (null? xs)
		xs
		(if (pair? xs)
			(append (mirror (cdr xs)) (list1 (mirror (car xs))))
			xs)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1d   ---   consider lists with embedded empty lists...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define flatten (xs)
	(if (null? xs)
		xs
		(if (atom? xs)
			(list1 xs)
			(append (flatten (car xs)) (flatten (cdr xs))))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1e
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; helper function to let me keep a handle on the original list
(define contig-sublist-helper (orig xs ys)
	(if (null? xs)						;if xs is null, we match
		#t
		(if (null? ys)					;if ys is null, no match
			#f
			(if (equal? (car xs) (car ys))
				(contig-sublist-helper orig (cdr xs) (cdr ys))
				(contig-sublist-helper orig orig (cdr ys))))))

(define contig-sublist? (xs ys)
	(contig-sublist-helper xs xs ys))



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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;9a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define cdr* (lists)
	(map cdr lists))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;9b
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define max* (xs)
	(foldr (lambda (x y) (if (> x y) x y)) (car xs) xs))	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;9g
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define append-hof (xs ys)
	(foldr cons ys xs))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;9i
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define reverse-hof (xs)
	(foldl cons '() xs))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;A. Take and drop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define take (n xs)
	(if (null? xs)
		xs
		(if (equal? n 0)
			'()
			(cons (car xs)(take (- n 1) (cdr xs))))))

(define drop (n xs)
	(if (null? xs)
		xs
		(if (equal? n 0)
			xs
			(drop (- n 1) (cdr xs)))))

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


(define operate (f xs)
	(zip xs (map f xs)))
(define car_greater? (x y)
        (if (> (cadr x) (cadr y)) x y))
(define arg-max (f A)
	(car (foldr car_greater? (car (operate f A)) (operate f A)))) 

; in one big mess
;(define arg-max (f A)
;	(car (foldr (lambda (x y) (if (> (cadr x) (cadr y)) x y)) (car (zip A (map f A))) (zip A (map f A)))))




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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;E. Interleaving lists - key here is to switch xs and ys with each recursion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define interleave (xs ys)
	(if (null? xs)
		(if (null? ys)
			ys
			(interleave ys xs))
		(cons (car xs) (interleave ys (cdr xs)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;F. Working with trees
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define to-prefix (xs)
	(if (pair? (car xs))		; if the first element is a sub expression
		(if (pair? (caddr xs))	; if the third element is a sub expression
			(list3 (cadr xs) (to-prefix (car xs)) (to-prefix (caddr xs)))
			(list3 (cadr xs) (to-prefix (car xs)) (caddr xs)))
		(if (pair? (caddr xs))
			(list3 (cadr xs) (car xs) (to-prefix (caddr xs)))
			(list3 (cadr xs) (car xs) (caddr xs)))))




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





