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

(write (cdr (cons 3 4)))
(write (car (cons 3 4)))
;(repl)
