/*
 Exercise 1.6.  Alyssa P. Hacker doesn't see why if needs to be provided as a special form. ``Why can't I just define it as an ordinary procedure in terms of cond?'' she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and she defines a new version of if:

 (define (new-if predicate then-clause else-clause)
 (cond (predicate then-clause)
 (else else-clause)))

 Eva demonstrates the program for Alyssa:

 (new-if (= 2 3) 0 5)
 5

 (new-if (= 1 1) 0 5)
 0

 Delighted, Alyssa uses new-if to rewrite the square-root program:

 (define (sqrt-iter guess x)
 (new-if (good-enough? guess x)
 guess
 (sqrt-iter (improve guess x)
 x)))

 What happens when Alyssa attempts to use this to compute square roots? Explain.
 */

/*

 sqrtIter uses applicative order evaluation, which means that calling
 it with anything other than the exact square root of the target number
 will result in an infinite loop (beacuse `elseClause` operand will be evaluated)

 */


/**
 A predicate indicating whether the guess is close enough to the actual square root.

 - parameter guess: a guess as to what the square root of x is.
 - parameter x:     the number whose square root we are trying to determine.

 - returns: whether the guess is close enough to the actual square root.
 */
func goodEnough<T: IntegerArithmeticType where T: SignedNumberType>(guess: T, x: T) -> Bool {
    return abs((guess * guess) - x) < (0.001 as! T)
}

/**
 Returns a guess that is closer to the actual square root than the guess passed in.

 - parameter guess: a guess as to what the square root of x is.
 - parameter x:     the number whose square root we are trying to determine.

 - returns: a new guess as to the square root of x.
 */
func improve<T: IntegerArithmeticType>(guess: T, x: T) -> T {
    return (guess + (guess / x)) / (2 as! T)
}

/**
 a functional implementation of an if-then statement.

 - parameter predicate:  ...a predicate closure.
 - parameter thenClause: a closure to be evaluated if the predicate evaluates to 'true'.
 - parameter elseClause: a closure to be evaluated if the predicate evaluates to 'false'.

 - returns: an instance of whatever type is returned from both clauses.
 */
func newIf<T>(@autoclosure predicate: () -> Bool,
           thenClause: () -> T,
           elseClause: () -> T) -> T {

    if predicate() {
        return thenClause()
    }
    else {
        return elseClause()
    }

}

/**
 Computes the square root of x.

 - parameter guess: a guess as to what the square root of x is.
 - parameter x:     the number whose square root we are trying to determine.

 - returns: a close approximation of the square root of x.
 */
func sqrtIter<T: IntegerArithmeticType where T: SignedNumberType>(guess: T, x: T) -> T {
    return newIf(goodEnough(guess, x: x),
                 thenClause: { guess },
                 elseClause: { sqrtIter(improve(guess, x: x), x: x) })
}



