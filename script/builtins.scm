;(define cons 
  ;(lambda (x y)
	;(lambda (pos)
	  ;(if (= pos 0) x y))))

;(define car
  ;(lambda (x)
	;(x 0)))

;(define cdr
  ;(lambda (x)
	;(x 1)))

(define print_list
	(lambda (l)
	  (write (car l))
	  (if (= (cdr l) nil) 0 (print_list (cdr l)))))



(write (cdr (cons 3 4)))
(write (car (cons 3 4)))
(define l (list 1 2 3))

;; (print_list ((lambda (x) (list x (list (quote quote) x)))
;;   (quote (lambda (x) (list x (list (quote quote x)))))))

(define gen-range 
  (lambda (from till)
    (if (= from till) 
	(cons from nil)
	(cons from (gen-range (+ from 1) till)))))


(define make-counter
  (lambda ()
    (define counter 0)
    (lambda () 
      (set! counter (+ counter 1))
      counter)))

(define foldr
  (lambda (lst fun initial)
    (if (= nil lst) 
	initial
	(fun (car lst) (foldr (cdr lst) fun initial)))))

(define sum-list 
  (lambda (lst)
    (foldr lst + 0)))

(define mult-list
  (lambda (lst)
    (foldr lst * 1)))

(define length
  (lambda (lst)
    (define counter (make-counter))
    (foldr lst counter 0)))

(define fun-and-cons 
  (lambda (fun)
    (lambda (head tail)
      (cons (fun head) tail))))

(define map
  (lambda (fun list)
    (foldr list (fun-and-cons fun) nil)))

(define l2 (list 4 5 6))

(define append
  (lambda (l1 l2)
    (foldr l1 cons l2)))

;; (define build-counters
;;   (lambda (till)
;;     (define list (gen-range 1 till))
;;     (map (lambda (x) 
;; 	   (lambda ()
;; 	     (set! x (+ x 1))
;; 	     x)) 
;; 	 list)))
(let ((a 34)) (+ a 1))
(define (fact n)
  (if (= n 1)
      1
      (* (fact (- n 1))
	 n)))


(repl)
