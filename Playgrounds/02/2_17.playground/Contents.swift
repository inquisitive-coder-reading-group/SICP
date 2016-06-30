/*
Exercise 2.17.  Define a procedure last-pair that returns the list that contains only the last element of a given (nonempty) list:

(last-pair (list 23 72 149 34))
(34)
*/


/*
    Example Usage: lastPair(List.Cons(1, List.Cons(2, List.Cons(3, List.Empty))))
*/

enum List<T> {
    case Empty
    indirect case Cons(T, List<T>)
}

func lastPair<T>(list: List<T>) -> T? {
    switch list {
        case .Empty:
            return nil
        case .Cons(let car, let cdr):
            switch cdr {
                case .Empty:
                    return car
                default:
                    return lastPair(cdr)
        }
    }
}
