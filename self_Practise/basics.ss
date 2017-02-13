;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Semi-colons start comments anywhere on a line.
;;
;; Scheme programs are made of symbolic expressions (s-exps):
(+ 2 2)

;; This symbolic expression reads as "Add 2 to 2".

;; Sexps are enclosed into parentheses, possibly nested:
(+ 2 (+ 1 1))

;; A symbolic expression contains atoms or other symbolic
;; expressions.  In the above examples, 1 and 2 are atoms,
;; (+ 2 (+ 1 1)) and (+ 1 1) are symbolic expressions.

(+ 3 (+ 1 2))
;; => 6

;; `set!' stores a value into a variable:
;; Please define my-name first, or you can't assign it.
(define my-name "unknown")
(set! my-name "NalaGinrut")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1. Primitive Datatypes and Operators
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Numbers
9999999999999999999999 ; integers
#b111                  ; binary => 7
#o111                  ; octal => 73
#x111                  ; hexadecimal => 273
3.14                   ; reals
6.02e+23
1/2                    ; rationals
1+2i                   ; complex numbers

;; Function application is written (f x y z ...)
;; where f is a function and x, y, z, ... are operands
;; If you want to create a literal list of data, use ' to stop it from
;; being evaluated
'(+ 1 2) ; => (+ 1 2)
;; Now, some arithmetic operations
(+ 1 1)  ; => 2
(- 8 1)  ; => 7
(* 10 2) ; => 20
(expt 2 3) ; => 8
(quotient 5 2) ; => 2
(remainder 5 2) ; => 1
(/ 35 5) ; => 7
(/ 1 3) ; => 1/3
(exact->inexact 1/3) ; => 0.3333333333333333
(+ 1+2i  2-3i) ; => 3-1i

;;; Booleans
#t ; for true
#f ; for false -- any value other than #f is true
(not #t) ; => #f
(and 0 #f (error "doesn't get here")) ; => #f
(or #f 0 (error "doesn't get here"))  ; => 0

;;; Characters
;; According to RnRs, characters only have two notations:
;; #\ and #\x
;; Racket support #\u, but it's never Scheme.
#\A ; => #\A
#\λ ; => #\λ
#\x03BB ; => #\λ

;;; Strings are fixed-length array of characters.
"Hello, world!"
"Benjamin \"Bugsy\" Siegel"   ; backslash is an escaping character
"Foo\tbar\x21\a\r\n" ; includes C escapes (only support hex)
;; try to print the above string
;; Printing is pretty easy
(display "I'm Guile. Nice to meet you!\n")
;; and unicode escapes
"\u004B" ; => K

;; Strings can be added too!
(string-append "Hello " "world!") ; => "Hello world!"

;; A string can be treated like a list of characters
(string-ref "Apple" 0) ; => #\A

;; format can be used to format strings:
(format #t "~a can be ~a" "strings" "formatted")
;; ==> print "strings can be formatted" on screen
(define str (format #f "~a can be ~a" "strings" "formatted"))
;; str was assigned to "strings can be formatted"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2. Variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; You can create a variable using define
;; a variable name can use any character except: ()[]{}",'`;#|\
(define some-var 5)
some-var ; => 5

;; Accessing a previously unassigned variable is an exception
; x ; => x: undefined ...

;; Local binding: `me' is bound to "Bob" only within the (let ...)
(let ((me "Bob"))
  "Alice"
  me) 
;; => "Bob"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. Structs and Collections
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Record Type (Skip this chapter if you're trying web version
(use-modules (srfi srfi-9))
(define-record-type dog 
  (make-dog name breed age)
  dog?
  (name dog-name)
  (breed dog-breed)
  (age dog-age))
(define my-pet
  (make-dog "lassie" "collie" 5))
my-pet ; => #<dog>
(dog? my-pet) ; => #t
(dog-name my-pet) ; => "lassie"

;;; Pairs (immutable)
;; `cons' constructs pairs, `car' and `cdr' extract the first
;; and second elements
(cons 1 2) ; => '(1 . 2)
(car (cons 1 2)) ; => 1
(cdr (cons 1 2)) ; => 2

;;; Lists

;; Lists are linked-list data structures, made of `cons' pairs and end
;; with a '() to mark the end of the list
(cons 1 (cons 2 (cons 3 '()))) ; => '(1 2 3)
;; `list' is a convenience variadic constructor for lists
(list 1 2 3) ; => '(1 2 3)
;; and a quote can also be used for a literal list value
'(1 2 3) ; => '(1 2 3)

;; Can still use `cons' to add an item to the beginning of a list
(cons 4 '(1 2 3)) ; => '(4 1 2 3)

;; Use `append' to add lists together
(append '(1 2) '(3 4)) ; => '(1 2 3 4)

;; Lists are a very basic type, so there is a *lot* of functionality for
;; them, a few examples:
;; For Racket users:
(map add1 '(1 2 3))          ; => '(2 3 4)
;; For Guile users:
(map 1+ '(1 2 3))	     ; => '(2 3 4)
;; add1 or 1+ is not a standard primitive, so it depends on implementations.

(map + '(1 2 3) '(10 20 30)) ; => '(11 22 33)

;; filter/count/take/drop are dwell in SRFI-1, so you have to load it first.
;; For Racket users:
(require srfi/1)
;; For Guile users:
(use-modules (srfi srfi-1))

(filter even? '(1 2 3 4))    ; => '(2 4)
(count even? '(1 2 3 4))     ; => 2
(take '(1 2 3 4) 2)          ; => '(1 2)
(drop '(1 2 3 4) 2)          ; => '(3 4)

;;; Vectors

;; Vectors are fixed-length arrays
#(1 2 3) ; => '#(1 2 3)

;; Use `vector-append' to add vectors together
;; NOTE: vector-append is in SRFI-43 which is not supported in Guile-2.0.9
;;       or earlier. And it may not be added in Guile-2.0.10.
;;       But it's proposed in R7RS, and there's a r7rs branch in Guile upstream.
;;       If your Guile doesn't support vector-append, please skip this step.
(vector-append #(1 2 3) #(4 5 6)) ; => #(1 2 3 4 5 6)

;;; Hashes

;; Create mutable hash table
;; For GNU Guile
(define m (make-hash-table))
(hash-set! m 'a 1)
(hash-set! m 'b 2)
(hash-set! m 'c 3)

;; Retrieve a value
(hash-ref m 'a) ; => 1

;; Retrieving a non-present value is an exception
(hash-ref m 'd) 
;; => #f 

;; You can provide a default value for missing keys
(hash-ref m 'd 0)
;; => 0

;; Use `hash-remove' to remove keys (functional too)
(hash-remove! m 'a) ; => ((b . 2) (c . 3))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use `lambda' to create functions.
;; A function always returns the value of its last expression
(lambda () "Hello World") ; => #<procedure>

;; Use parens to call all functions, including a lambda expression
((lambda () "Hello World")) ; => "Hello World"
((lambda (x) (+ x x)) 5)      ; => 10

;; Assign a function to a var
(define hello-world (lambda () "Hello World"))
(hello-world) ; => "Hello World"

;; You can shorten this using the function definition syntatcic sugar:
(define (hello-world2) "Hello World")
(hello-world2) ; => "Hello World"

;; The () in the above is the list of arguments for the function
(define hello
  (lambda (name)
    (string-append "Hello " name)))
(hello "Steve") ; => "Hello Steve"
;; ... or equivalently, using a sugared definition:
(define (hello2 name)
  (string-append "Hello " name))
