/*
 Exercise 2.17.  Define a procedure last-pair that returns the list that contains only the last element of a given (nonempty) list:

 (last-pair (list 23 72 149 34))
 (34)
 */


/*
 Example Usage: lastPair(List.Cons(1, List.Cons(2, List.Cons(3, List.Empty))))
 */

enum List<T> {
    case empty
    indirect case cons(T, List<T>)
}

func lastPair<T>(_ list: List<T>) -> T? {
    switch list {
    case .empty:
        return nil
    case .cons(let car, let cdr):
        switch cdr {
        case .empty:
            return car
        default:
            return lastPair(cdr)
        }
    }
}
