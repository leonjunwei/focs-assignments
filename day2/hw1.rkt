#lang racket

;;; Student Name: Leon [change to your name]
;;;
;;; Check one:
;;; [ ] I completed this assignment without assistance or external resources.
;;; [X] I completed this assignment with assistance from ___
;;;     and/or using these external resources: https://racket-lang.org/, stackoverflow

;;     NOTE:  You need not worry about error checking in the programs below.

;; 1.  WRITE SQUARE:  given n, returns n^2.  Hint:  use *
(define (square x)
  (* x x))
  
(display (square 2)) (newline)  ;; -> 4

;; 2.  WRITE is-right-triangle:  given three numbers, returns true iff the third
;;     could be the hypotenuse of a right triangle with the specified three side lengths
;;     Hint:  use = to compare numeric values

(define (is-right-triangle x y z)
  (= (+ (* x x) (* y y)) (* z z)))
  
(display (is-right-triangle 3 4 5)) (newline)  ;; -> #t
(display (is-right-triangle 4 5 6)) (newline)  ;; -> #f



;; 3.  WRITE FACTORIAL:  given n, returns n!
;;     Hint:  recursion is your friend
(define (fact n)
  (if (> n 1)
      (* n (fact(- 1 n)))
      1))
  
(display (fact 1)) (newline) ;; -> 1
(display (fact 2)) (newline) ;; -> 1 SHOULD THIS BE 2? GOOGLE SAYS 2 FACTORIAL IS 2 BUT I'M NOT CONFIDENT.


;; 4.  WRITE FIBONACCI:  given n, returns the nth fibonacci number as shown below
;;     Hint:  don't run this on really big numbers!
(define (fib n)
   (if (< n 3)
       1
       (+ (fib(- n 1)) (fib(- n 2)))
  )
  )


(display (fib 1)) (newline) ;; -> 1
(display (fib 2)) (newline) ;; -> 1
(display (fib 3)) (newline) ;; -> 2
(display (fib 4)) (newline) ;; -> 3
(display (fib 5)) (newline) ;; -> 5
(display (fib 6)) (newline) ;; -> 8



;; 5.  WRITE a procedure that takes a list of numbers and returns the sum of those numbers
;;     Hint:  first, rest, cons
(define (sum lst)
  (if (null? (rest lst))
      (first lst)
      (+ (first lst) (sum(rest lst)))
  )
  )


(display (sum '(1 2 3 4))) (newline) ;; -> 10
(display (sum '(1 20 300))) (newline) ;; -> 321



;; 6.  WRITE a procedure that takes a list of numbers and returns the largest one.
;;     While there are solutions using scheme's built-in max, we were actually hoping you'd do something else...
(define (my-max lst)
  (define b 0)
  (for ([i lst])
   (if (> i b)
       (set! b i)
       (void)
       )
    )
  b
  )
  
(display (my-max (list 1 10 2 20 3))) (newline) ;; -> 20


