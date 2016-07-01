/*
 Exercise 1.10.  The following procedure computes a mathematical function called Ackermann's function.

 (define (A x y)
 (cond ((= y 0) 0)
 ((= x 0) (* 2 y))
 ((= y 1) 2)
 (else (A (- x 1)
 (A x (- y 1))))))

 What are the values of the following expressions?

 (A 1 10)

 (A 2 4)

 (A 3 3)

 Consider the following procedures, where A is the procedure defined above:

 (define (f n) (A 0 n))

 (define (g n) (A 1 n))

 (define (h n) (A 2 n))

 (define (k n) (* 5 n n))

 Give concise mathematical definitions for the functions computed by the procedures f, g, and h for positive integer values of n. For example, (k n) computes 5n2.
 */

func A(x: Int, y:Int) -> Int {
    switch (x, y) {
    case let (_, y) where y == 0:
        return y
    case let (x, _) where x == 0:
        return 2 * y
    case let (_, y) where y == 1:
        return 2
    default:
        return A((x - 1), y: (A(x, y: (y - 1))))
    }
}

A(1, y: 10)

A(2, y: 4)

A(3, y: 3)
