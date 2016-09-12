#lang racket

;;; Student Name: Leon Lam [change to your name]
;;;
;;; Check one:
;;; [ ] I completed this assignment without assistance or external resources.
;;; [X] I completed this assignment with assistance from Emily Yeh (formatting)
;;;     and/or using these external resources: Racket Documentation

;;; 1.  Create a calculator that takes one argument: a list that represents an expression.

#|
Calc needs to work on a single number and on a list. If called on a number X, it returns X
If called on a list '(PROC Y Z), it maps PROC to a helper function, then calls proc's corresponding function on calc(Y) and calc(Z).
This means that even if Y and Z are lists with arbitrary depth, they should be processed first.

ADD, SUB, MUL and DIV now work on arbitrarily many inputs.

|#

(define (sum lst)
  (if (null? (rest lst))
      (calculate (first lst))
      (+ (calculate(first lst)) (sum(rest lst)))
  )
  )

(define (subtract lst) ;Subtract with three or more arguments subtracts (the sum of the rest) from the first.
  (if (null? (rest lst))
      (calculate (first lst))
      (- (calculate(first lst)) (sum(rest lst)))
  )
  )

(define (multiply lst)
  (if (null? (rest lst))
      (calculate (first lst))
      (* (calculate(first lst)) (sum(rest lst)))
  )
  )

(define (divide lst)
  (if (null? (rest lst))
      (calculate (first lst))
      (/ (calculate(first lst)) (sum(rest lst)))
  )
  )


(define (calculate x)
  (if (not(pair? x))
      x                      ;;if x is not a list, it should be a number. Return the number.
      (cond
       ; [(equal? (first x) 'ADD) (+ (calculate (first (rest x))) (calculate (last (rest x))))]
        [(equal? (first x) 'ADD) (sum (rest x))]
        [(equal? (first x) 'SUB) (subtract (rest x))]
        [(equal? (first x) 'MUL) (multiply (rest x))]
        [(equal? (first x) 'DIV) (divide (rest x))]
        [(equal? (first x) 'GT) (> (calculate (first (rest x))) (calculate (last (rest x))))]
        [(equal? (first x) 'LT) (< (calculate (first (rest x))) (calculate (last (rest x))))]
        [(equal? (first x) 'GE) (>= (calculate (first (rest x))) (calculate (last (rest x))))]
        [(equal? (first x) 'LE) (<= (calculate (first (rest x))) (calculate (last (rest x))))]
        [(equal? (first x) 'EQ) (= (calculate (first (rest x))) (calculate (last (rest x))))]
        [(equal? (first x) 'NEQ) (not (= (calculate (first (rest x))) (calculate (last (rest x)))))]
        [(equal? (first x) 'AND) (and (calculate (first (rest x))) (calculate (last (rest x))))]
        [(equal? (first x) 'OR) (or (calculate (first (rest x))) (calculate (last (rest x))))]
        [(equal? (first x) 'NOT) (not (calculate (rest x)))] ; I don't actually know how this is used - I'm assuming it flips a single boolean.
        [(equal? (first x) 'IPH) (if (calculate (first (rest x))) (calculate (first (rest (rest x)))) (calculate (last (rest (rest x)))))]
        ;IPH takes one extra variable - the test clause.
        )
      )
  )


(calculate '(ADD 1 2 (ADD 3 4 5)))
(calculate '(ADD 1 (ADD 2 (ADD 3 4 5))))
(calculate '(ADD 1 2 3 4 5))
(calculate '(SUB 1 2 3 (ADD 4 5 6)))
(calculate '(ADD 3 4)) ;; --> 7

;;; 2. Expand the calculator's operation to allow for arguments that are themselves well-formed arithmetic expressions.

(calculate '(ADD 3 (MUL 4 5))) ;; --> 23   ;; what is the equivalent construction using list?
(calculate '(SUB (ADD 3 4) (MUL 5 6))) ;; --> -23



;;; 3. Add comparators returning booleans (*e.g.*, greater than, less than, …).
;; Note that each of these takes numeric arguments (or expressions that evaluate to produce numeric values),
;; but returns a boolean.  We suggest operators `GT`, `LT`, `GE`, `LE`, `EQ`, `NEQ`.

	(calculate '(GT (ADD 3 4) (MUL 5 6))) ;; --> #f
	(calculate '(LE (ADD 3 (MUL 4 5)) (SUB 0 (SUB (ADD 3 4) (MUL 5 6))))) ;; --> #t
    (calculate '(EQ (ADD 3 9) (MUL 2 6)))
    (calculate '(NEQ (ADD 3 9) (MUL 2 6)))

;;; 4. Add boolean operations ANND, ORR, NOTT

(calculate '(AND (GT (ADD 3 4) (MUL 5 6)) (LE (ADD 3 (MUL 4 5)) (SUB 0 (SUB (ADD 3 4) (MUL 5 6)))))) ;; --> #f

;;; 5. Add IPH

(calculate '(IPH (GT (ADD 3 4) 7) (ADD 1 2) (ADD 1 3))) ;; -> 4
