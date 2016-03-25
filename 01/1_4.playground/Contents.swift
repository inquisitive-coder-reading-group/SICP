/*
Exercise 1.4: Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procedure:

(define (a-plus-abs-b a b)
((if (> b 0) + -) a b))

*/

func aPlusAbsB<T: IntegerArithmeticType where T: SignedNumberType>(a: T, b: T) -> T {
    return a + abs(b)
}

/**
*  An `if` conditional returns an addition operator if b
*  is greater than zero, otherwise it returns a subtraction 
*  operator. Then, that operator is applied to operands a and b.
*/
