import Foundation

/*
Exercise 1.3: Define a procedure that takes 3 numbers as arguments and returns the sum of the squares of the 2 larger numbers
*/

func sumOfSquares(a: Int, b: Int, c: Int) -> Int {
    let squares = [a, b, c].sort({ $0 < $1 }).dropFirst(1).map({ $0 * $0 })
    return squares.reduce(0, combine: +)
}
