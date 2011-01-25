(define cons 
  (lambda (x y)
	(lambda (pos)
	  (if (= pos 1) x y))))

(define car
  (lambda (x)
	(x 1)))

(define cdr
  (lambda (x)
	(x 2)))

(define list 
    (lambda (x y z)
      (cons x (cons y (cons z nil)))))

(define plist
    (lambda (l)
      (write (car l))
      (if (= (cdr l) nil) 0 (plist (cdr l)))))

(write (cdr (cons 3 4)))
(write (car (cons 3 4)))
(repl)
