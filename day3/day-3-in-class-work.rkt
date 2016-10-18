#lang racket

;;;;;;;;;;
;;; Day 3 in class work

;;;;;;;;;;
;; 0.  Implement factorial both recursively and tail recursively.
;;     Hint:  The tail recursive version will use a helper function.

#| Factorial |#


(define (factorial x)
  (second (fac x 1))
  )

(define (fac y so-far) ; given (5, 1) -> (4, 5) -> (3, 20), -> (2, 60), -> (1, 120) -> (0,120)
  (if (= y 0)
      (list y so-far)
      (fac (- y 1) (* y so-far))
      )
  )

(factorial 5)


#| Filter |#

(define (my-filter func lst)
  (last (filterH func lst empty))
  )

(define (filterH func lst so-far)

  (if (null? lst)
      (list so-far)
      (if (func (first lst))
          (filterH func (rest lst) (append so-far (list (first lst))))
          (filterH func (rest lst) so-far)
          )
      )
  )
  

(my-filter even? '(1 2 3 4 5 6 7 8))
(my-filter list? '(3 (3 2 1 ) symbol (4 2) (1 (2) 3)))

#| Map |#

(define (my-map func lst) 
  (mapH func lst empty)
  )


(define (mapH func lst so-far) ;takes in a function, the rest of a list to apply the function to, and the result thus far. 
  (if (null? lst)
      so-far
      (mapH func (rest lst) (append so-far (list (func (first lst)))))
  )
  )
  

(my-map add1 '(3 4 5 6))
(my-map (lambda (x) (* x 2)) '(1 2 3 4))

#| Reverse |#

;(cons A B) returns A added to the beginning of B!

(define (reverseH lst so-far)
  (if (null? lst)
      so-far
      (reverseH (rest lst)(cons (first lst) so-far))
  )
  )
(reverseH '(1 2 3 4) empty)

(define (my-reverse lst)
  (reverseH lst empty)
  )

(my-reverse '(1 2 3 4 5))



#| Append (and drop-right, which uses my-reverse) |#

(define (drop-right lst so-far)
  (if (null? (rest lst))
      (my-reverse so-far)
      (drop-right (rest lst) (cons (first lst) so-far))
      )     
  )

(drop-right '(1) empty)


;(define (my-append lst1 lst2)
;  (appendH lst1 lst2)
;  )

(define (my-append lst1 lst2) ;Originally this was called appendH
  (if (null? lst1)
      lst2
      (my-append (drop-right lst1 empty) (cons (last lst1) lst2))
  )
  )

(my-append '(1 2 3) '(4 5 6))

#| Zip |#

(define (my-flatzip lst1 lst2)
  (my-reverse (zipH lst1 lst2 empty))
  )


(define (zipH lst1 lst2 so-far)
  (cond [(null? lst1) so-far]
        [(null? lst2) so-far]
        [else (zipH (rest lst1) (rest lst2) (cons (list (first lst1) (first lst2)) so-far))]
        )
  )

(my-flatzip '(1 2 3) '(4 5 6))
(my-flatzip '(1 2 3) '(a b c d e f g))


#| Count |#

(define (my-count elt lst)
  (countH elt lst 0)
  )

(define (countH elt lst so-far)
  (if (null? lst)
      so-far
      (if (eq? (first lst) elt)
          (countH elt (rest lst) (+ 1 so-far))
          (countH elt (rest lst) so-far)
          )
  )
  )

(my-count 2 '(1 2 3 4 2 5 2 2 2 2))
;;;;;;;;;;;
;; 1.  Filter is built in to scheme.

;; (filter even? '(1 2 3 4 5 6))  --> '(2 4 6)  ;; using the built-in even?
;; (filter teen? '(21 17 2 13 4 42 2 16 3)) --> '(17 13 16)
                        ;; assuming (define (teen x) (and (<= 13 x) (<= x 19)))))
;; (filter list? '(3 (3 2 1) symbol (4 2) (1 (2) 3)) --> '((3 2 1) (4 2) (1 (2) 3))

;; Implement it anyway.  You might want to call it my-filter?  What arguments does it take?





;;;;;;;;;;;
;; 2.  Map is also built in to scheme.

;; (map double '(1 2 3))  --> '(4 5 6)  ;; assuming (define (double x) (* 2 x))
;; (map incr '(1 2 3)) --> '(2 3 4)     ;; assuming (define (incr x) (+ x 1))
;; (map last '((3 2 1) (4 2) (1 2 3)) --> '(1 2 3)
                                        ;; assuming (define (last lst)
                                        ;;            (if (null? (rest lst))
                                        ;;                (first lst)
                                        ;;                (last (rest lst))))

;; Implement it as well.  You might want to call it my-map.  What arguments does it take?







;;;;;;;;;;;
;; 3.  While we're reimplementing built-ins, implement my-append (just like built in append)
;;     It takes two lists and returns a list containing all of the elements of the originals, in order.
;;     Note that it is purely functional, i.e., it doesn't MODIFY either of the lists that it is passed.

;; (append '(1 2 3) '(4 5 6)) --> '(1 2 3 4 5 6)

;; You might want to draw out the box and pointer structures for the original two lists
;; as well as for the new list.  Confirm with a member of the instructional staff....





;;;;;;;;;;;
;; 4.  zip takes two lists, and returns a list of elements of size two, until one of the lists runs out.

;; (zip '(1 2 3) '(4 5 6)) ;; --> '((1 4) (2 5) (3 6))
;; (zip '(1 2 3) '(a b c d e f g)) ;; --> '((1 a) (2 b) (3 c))

;; Implement `zip`.




;;;;;;;;;;;;
;; 5.  Last built-in (for now):  (my-)reverse.
;;     Takes a list, returns a new list with the elements reversed.

;; (reverse '(1 2 3)) --> '(3 2 1)



;;;;;;;;;;;;
;; More puzzles:
;;
;;  - (count elt lst) returns the number of times that elt appears in lst
;;  - (remove-dups lst) returns a new list that contains the elements of lst but without repeats
;;       (remove-dups '(1 2 3 1 4 5 2 4 6)) --> '(1 2 3 4 5 6)
;;  - reverse reverses a list, but doesn't reverse sublists in a tree.  (Try it and see.)
;;    Write deep-reverse, which reverses all sublists as well.
;;  - Which of these can you implement using tail recursion?
