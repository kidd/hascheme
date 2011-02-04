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
    (define gen-range-accum 
      (lambda (from till acc)
	(if (= from till) 
	    acc
	    (cons from (gen-range-accum (+ from 1) till acc))))
      (gen-range-accum from till nil))
    (gen-range-accum from till nil)))

;; (define map 
;;   (lambda (fun lst)
;;     ))

;; (define build-counters
;;   (lambda (till)
;;     (define list (gen-range 1 till))
;;     (map (lambda (x) 
;; 	   (lambda ()
;; 	     (set! x (+ x 1))
;; 	     x)) 
;; 	 list)))

(repl)
