import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


/*
 Exercise 1.3: Define a procedure that takes 3 numbers as arguments and returns the sum of the squares of the 2 larger numbers
 */

func sumOfSquares<T: IntegerArithmetic>(_ a: T, b: T, c: T) -> T {
    let squares = [a, b, c]
    let sortedSquares = squares.sorted(by: { $0 < $1 }).dropFirst().map({ $0 * $0 })
    return sortedSquares.reduce(0 as! T, +)
}
