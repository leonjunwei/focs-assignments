#lang racket

;;; Student Name: Leon Lam [change to your name]
;;;
;;; Check one:
;;; [ ] I completed this assignment without assistance or external resources.
;;; [X] I completed this assignment with assistance from ___
;;;     and/or using these external resources: Homework 2 soln's calculate function (much neater than mine, plus self-evaluation already included)

;;;;;;;;;;;
;; 1. assq

;; `assq` is a function that takes a key and an association list.
;;
;; It returns the corresponding key/value pair from the list
;; (*i.e.*, the pair whose key is *eq?* to the one it is given).
;;
;; If the key is not found in the list, `assq` returns `#f`.

(define operator-list
  (list (list 'ADD +)
        (list 'SUB -)
        (list 'MUL *)
        (list 'DIV /)
        (list 'GT >)
        (list 'LT <)
        (list 'GE >=)
        (list 'LE <=)
        (list 'EQ =)
        (list 'NEQ (lambda (x y) (not (= x y))))
        (list 'AND (lambda (x y) (and x y)))
        (list 'OR (lambda (x y) (or x y)))
        (list 'NOT not)))
#|
lst is a list with key(s) and value(s).
lst could be a nonnested list '(x 1).
lst could be a nested list '((x 1)(y 2))
|#

(define (my-assq key lst)
  (cond
    [(not (list? (first lst))) (if (eq? key (first lst))
                                   (second lst)
                                   #f)]
    [else (if (eq? key (first (first lst)))
              (second (first lst))
              (my-assq key (rest lst))
              )]
    )
  )

(my-assq 'x '((y 1)(x 2))) ;; Just returns 2 now


;;;;;;;;;;;
;; 2. lookup-list

;; Add the ability to look up symbols to your evaluator.
;;
;; Add the `lookup-list` argument to your hw2 evaluator (or ours, from the solution set).
;; `(evaluate 'foo lookup-list)` should return whatever `'foo` is associated with in `lookup-list`.

#| Using hw2 solution evaluator|#

(define (apply-operator op args)
  ;(display (list op args))
  (cond [(eq? op 'ADD) (+ (first args) (second args))]
        [(eq? op 'SUB) (- (first args) (second args))]
        [(eq? op 'MUL) (* (first args) (second args))]
        [(eq? op 'DIV) (/ (first args) (second args))]
        [(eq? op 'GT) (> (first args) (second args))]
        [(eq? op 'LT) (< (first args) (second args))]
        [(eq? op 'GE) (>= (first args) (second args))]
        [(eq? op 'LE) (<= (first args) (second args))]
        [(eq? op 'EQ) (= (first args) (second args))]
        [(eq? op 'NEQ) (not (= (first args) (second args)))]
        [(eq? op 'AND) (and (first args) (second args))]
        [(eq? op 'OR) (or (first args) (second args))]
        [(eq? op 'NOT) (not (first args))]
        [(eq? op 'IPH) (if (first args) (second args) (third args))]
        [else (error "Don't know how to " op)]))

(define (evaluate expr lookup-list)
  (cond [(number? expr) expr]   ;; these first three cases are sometimes called
        [(boolean? expr) expr]  ;; self-evaluating (because they are their own
        [(null? expr) expr]     ;; values and don't need explicit evaluating)
        [(symbol? expr) (my-assq expr lookup-list)]
        [(list? expr) (apply-operator (first expr) (map (lambda (i) (evaluate i lookup-list)) (rest expr)))]
        [else (error `(evaluate:  not sure what to do with expr ,expr))]))

(define lookup '((x 3) (y 12) (z 2)))
(evaluate '(ADD y 4) lookup)
(evaluate '(AND (GT (ADD x 4) (MUL 5 6)) (LE (ADD 3 (MUL 4 5)) (SUB 0 (SUB (ADD 3 4) (MUL 5 6))))) lookup)
(evaluate '(IPH (GT (ADD x 4) 7) (ADD 1 2) (ADD 1 3)) lookup) ;; -> 4
