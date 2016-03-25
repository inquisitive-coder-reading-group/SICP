import Foundation

// TODO: without the foundation import here an error will be thrown in relationship to the use of @autoclosure... its a mystery, try it!

/*
Exercise 1.1.  Below is a sequence of expressions. What is the result printed by the interpreter in response to each expression? Assume that the sequence is to be evaluated in the order in which it is presented.
*/


/*
10
*/
10

/*
(+ 5 3 4)
*/
5 + 3 + 4

/*
(- 9 1)
*/
9 - 1

/*
(/ 6 2)
*/
6 / 2

/*
(+ (* 2 4) (- 4 6))
*/
(2 * 4) + (4 - 6)

/*
(define a 3)
*/
var a = 3

/*
(define b (+ a 1))
*/
var b = a + 1

/*
(+ a b (* a b))
*/
a + b + a + b

/*
(= a b)
*/
a == b

/*
(if (and (> b a) (< b (* a b)))
b
a)
*/
b > a && b < (a * b) ? b : a

/*
(cond ((= a 4) 6)
((= b 4) (+ 6 7 a))
(else 25))
*/
a == 4 ? 6 : b == 4 ? 6 + 7 + a : 25

/*
(+ 2
(if (> b a) b a)
)
*/
2 + (b > a ? b : a)

/*
(* (cond ((> a b) a)
((< a b) b)
(else -1))
(+ a 1))
*/

// This won't produce the correct answer in all cases because * (a+1) will only be applied if a > b. 

b == a ? -1 : (a > b) ? a : b * (a + 1)

// Sticking with a chained ternary, the answer would be:

b == a ? -1 : (a > b) ? a * (a + 1): b * (a + 1)

// The use of a chained ternary starts to fall apart with enough complexity. Another approach is to try and replicate some of the functionality of Lisp's cond function. Starting with a structure for a cond statement. The @autoclosure attribute allows us to pass in code that will be automatically wrapped in a closure so that the statement can be more lispy.

struct CondStatement {
    let test:  () -> Bool
    let expression: () -> AnyObject

    init(@autoclosure(escaping) _ test: () -> Bool, @autoclosure(escaping) _ expression: () -> AnyObject) {
        self.test = test
        self.expression = expression
    }
}

// The cond function which tasks an array of statements as well as
func cond(
    statements: [CondStatement],
    @autoclosure fallback: (() -> AnyObject?) = nil) -> AnyObject? {
    for statement in statements {
        if statement.test() {
            return statement.expression()
        }
    }

    return fallback()
}

// Returning back to the last problem:
/*
 (* (cond ((> a b) a)
 ((< a b) b)
 (else -1))
 (+ a 1))
 */

let conditions = [
    CondStatement(a > b, a),
    CondStatement(a < b, b)]

let z = (cond(conditions, fallback: -1) as? Int ?? 0) * a + 1
