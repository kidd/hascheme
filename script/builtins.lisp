(define cons 
  (lambda (x y)
	(lambda (pos)
	  (if (= pos 0) x y))))

(define car
  (lambda (x)
	(x 0)))

(define cdr
  (lambda (x)
	(x 1)))

(define plist
    (lambda (l)
      (write (car l))
      (if (= (cdr l) nil) 0 (plist (cdr l)))))

(write (cdr (cons 3 4)))
(write (car (cons 3 4)))
(define l (list 1 2 3))

(repl)
