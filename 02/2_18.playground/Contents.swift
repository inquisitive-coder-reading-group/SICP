/*
Exercise 2.18.  Define a procedure reverse that takes a list as argument and returns a list of the same elements in reverse order:

(reverse (list 1 4 9 16 25))
(25 16 9 4 1)
*/


/* 

Example usage: reverse(List.Cons(1, List.Cons(2, List.Cons(3, List.Empty)))

*/

enum List<T> {
    case Empty
    indirect case Cons(T, List<T>)
}

func reverse<T>(items: List<T>, result: List<T> = .Empty) -> List<T> {

    switch items {
        case .Empty:
            return result
        case .Cons(let car, let cdr):
            return reverse(cdr, result: List.Cons(car, result))
    }
    
}
