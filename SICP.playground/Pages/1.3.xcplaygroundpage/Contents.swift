import Foundation

/*
 Exercise 1.3: Define a procedure that takes 3 numbers as arguments and returns the sum of the squares of the 2 larger numbers
 */

func sumOfSquares<T: IntegerArithmeticType>(a: T, b: T, c: T) -> T {
    let squares = [a, b, c]
    let sortedSquares = squares.sort({ $0 < $1 }).dropFirst(1).map({ $0 * $0 })
    return sortedSquares.reduce(0 as! T, combine: +)
}
