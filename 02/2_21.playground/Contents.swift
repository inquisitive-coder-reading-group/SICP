/*

Exercise 2.21.  The procedure square-list takes a list of numbers as argument and returns a list of the squares of those numbers.

(square-list (list 1 2 3 4))
(1 4 9 16)

Here are two different definitions of square-list. Complete both of them by filling in the missing expressions:

(define (square-list items)
    (if (null? items)
    nil
    (cons <??> <??>)))

(define (square-list items)
(map <??> <??>))

*/

enum NumericList<T: IntegerArithmeticType> {
    case Empty
    indirect case Cons(T, NumericList)
}


func squareList<T>(list: NumericList<T>) -> NumericList<T> {
    switch list {
        case .Empty:
            return .Empty
        case .Cons(let car, let cdr):
            return .Cons(car * car, squareList(cdr))
    }
}


func squareListMap<T: IntegerArithmeticType>(items: [T]) -> [T] {
    return items.map({ $0 * $0 })
}

/*
 * Usage:
 squareListMap([1,2,3]) => [1,4,9]

 squareList(NumericList.Cons(1, 
    NumericList.Cons(2, 
    NumericList.Cons(3,
    NumericList.Empty))))
 
     => .Cons(1,
            NumericList.Cons(4,
            NumericList.Cons(9,
            NumericList.Empty))))
 */
