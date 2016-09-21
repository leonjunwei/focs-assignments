#lang racket

;;; Student Name: Leon Lam [change to your name]
;;;
;;; Check one:
;;; [ ] I completed this assignment without assistance or external resources.
;;; [X] I completed this assignment with assistance from ___
;;;     and/or using these external resources: Racket Documentation


;;;;;;;;;;; HELPER FUNCTIONS ;;;;;;;;;;;;


(define (reverseH lst so-far)
  (if (null? lst)
      so-far
      (reverseH (rest lst)(cons (first lst) so-far))
  )
  )

(define (my-reverse lst)
  (reverseH lst empty)
  )

(define (my-flatzip lst1 lst2)
  (my-reverse (zipH lst1 lst2 empty))
  )


(define (zipH lst1 lst2 so-far)
  (cond [(null? lst1) so-far]
        [(null? lst2) so-far]
        [else (zipH (rest lst1) (rest lst2) (cons (list (first lst1) (first lst2)) so-far))]
        )
  )

(define (zip-lambda lst) ;; Lambdas are a nice list like (lambda (arguments) (thing to do) (values of arguments))
  (my-flatzip (second (first lst)) (rest lst))
  )

(define (my-assq key lst) ;the key is one symbol, the lst can either be '((x 1) or '(x 1)(y 2))
;  (display lst)
  (cond
    [(null? lst) key]
    [(not (list? (first lst))) (if (eq? key (first lst))
                                   (second lst)
                                   key)]
    [else (if (eq? key (first (first lst)))
              (second (first lst))
              (my-assq key (rest lst))
              )]
    )
  )

(define (replace lst replaceLst) ;replaceLst is something like '((x 3) (y 2))
  (if (not (pair? lst))
      (if (not (equal? (my-assq lst replaceLst) lst));if the thingy is in replaceLst,
          (my-assq lst replaceLst)
          lst
      )
  (map (lambda (i) (replace i replaceLst)) lst)
  )
  )


(define (process-lambda lst)
  (replace (third (first lst)) (zip-lambda lst))
  )

(define a '((LAMBDA (n) (ADD n 1 )) 7))
(process-lambda a)

;(process-lambda '(LAMBDA (n) (ADD n 1) 7))

;; (my-assq 'x '((y 1)(x 2))) only returns 2 now
;; (my-assq 'x '((y 1)(x (1 2)))) returns (1 2)


;;;;;;;;;;; ACTUAL REPL ;;;;;;;;;;;;

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

(define (DEFINE? lst)
  (if (and (and (eq? (first lst) 'DEFINE) (symbol? (second lst)))(not (null? (third lst))))
      #t
      #f
      )
  )

(define (LAMBDACREATE? lst) ;; only creating lambda, not calling it
(if (not (pair? lst))
    #f
  (if (and (and (eq? (first lst) 'LAMBDA) (pair? (second lst)))(pair? (third lst)))
      #t
      #f
      ))
  )

(define (LAMBDA? lst)
  (if (not (LAMBDACREATE? (first lst)))
      #f

   (if (and (and (eq? (first (first lst)) 'LAMBDA) (pair? (second (first lst))))(pair? (third (first lst))))
      #t
      #f
      )
  ))

(define (apply-operator op args) ;if ((lambda (x y) (ADD x y)) 1 2) gets passed in, we have to associate x with 1, y with 2, then evaluate (ADD 1 2).
  ;(display args) (newline)
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
        [else (error "Don't know how to " (first args))]))


(define (evaluate expr lookup-list)
  ;(display expr) (newline)
  (cond [(eq? expr 'LOOKUP) lookup-list]
        [(number? expr) expr]   ;; these first three cases are sometimes called
        [(boolean? expr) expr]  ;; self-evaluating (because they are their own
        [(null? expr) expr]     ;; values and don't need explicit evaluating)
        [(symbol? expr) (my-assq expr lookup-list)]
        [(DEFINE? expr) (repl (append lookup-list (list (list (second expr) (evaluate (third expr) lookup-list)))))]
        [(LAMBDACREATE? expr) expr]
        [(LAMBDA? expr) (lambdaH lookup-list expr)]
        [(list? expr) (apply-operator (evaluate (first expr) lookup-list) (map (lambda (n) (evaluate n lookup-list)) (rest expr))) ] ; We're trying to use this to process both lambdas and normal lists, which is a problem.
        [else (error `(evaluate:  not sure what to do with expr ,expr))]))

;(evaluate (process-lambda '((LAMBDA (n) (ADD n 1 )) 7)) operator-list)
(define b '(LAMBDA (n) (ADD n 1 )))
(LAMBDA? (list b 7))


(define (lambdaH operator-list lst)
  (evaluate (process-lambda lst) operator-list)
  )


;(evaluate '(ADD 7 1) operator-list)

;(process-lambda '(LAMBDA (n) (ADD n 1) 7))
;(apply-operator '(n 7) '(LAMBDA (n) (+ n 1)))

(define (run-repl)
  (display "welcome to my repl.  type some scheme-ish")
  (repl operator-list))

(define (repl lookup)
  (display "> ")
  (display (myeval (read) lookup))
  (newline)
  (repl lookup))

(define (myeval sexpr lookup)
  (evaluate sexpr lookup))

(define (lambda-constructor lst); function name is lambda-constructor, input is lst = '(LAMBDA (n) (+ n 1))
   (list 'LAMBDA (second lst) (third lst)) ;should return (lambda (n) (+ n 1)) but doesn't
      )

;(lambda-constructor '(LAMBDA (n) (n+1)))


(run-repl)