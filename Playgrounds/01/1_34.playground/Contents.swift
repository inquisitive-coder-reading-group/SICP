/*
(define (f g)
    (g 2))

Then we have

(f square)
4

(f (lambda (z) (* z (+ z 1))))
6

What happens if we (perversely) ask the interpreter to evaluate the combination (f f)? Explain.
*/

/*
    --> Invoking (f f) will apply the argument 'f' to 2, which in turn sets 2 to 2 (presumably this will cause an error because '2' is not mutable).
*/
