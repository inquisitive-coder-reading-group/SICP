/*
Exercise 2.4.  Here is an alternative procedural representation of pairs. For this representation, verify that (car (cons x y)) yields x for any objects x and y.

(define (cons x y)
    (lambda (m) (m x y)))

(define (car z)
    (z (lambda (p q) p)))

(define (car z)
(z (lambda (p q) p)))

*/

/* 

Usage:

car(cons(1, b: 4))

cdr(cons(1, b: 4))

*/

func cons<T, U>(a: T, b: U) -> (T, U) {
    return (a, b)
}

func car<T, U>(x: (T, U)) -> T {
    return x.0
}

func cdr<T, U>(x: (T, U)) -> U {
    return x.1
}

