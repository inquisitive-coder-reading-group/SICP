/* Exercise 2.32:
 We can represent a set as a list of distinct elements, and we can represent the set of all subsets of the set as a list of lists. For example, if the set is (1 2 3), then the set of all subsets is (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3)). Complete the following definition of a procedure that generates the set of subsets of a set and give a clear explanation of why it works:
 (define (subsets s) (if (null? s)
 (list nil)
 (let ((rest (subsets (cdr s))))
 (append rest (map ⟨??⟩ rest))))) */


// We must first define a List type, with some basic operations like map and append
enum List<T> {
    case Empty
    indirect case Cons(T, List<T>)

    func map<U>(transform: T -> U) -> List<U> {
        switch self {
        case .Empty:
            return .Empty
        case .Cons(let first, let rest):
            return .Cons(transform(first), rest.map(transform))
        }
    }

    func append(other: List<T>) -> List<T> {
        switch self {
        case .Empty:
            return other
        case .Cons(let first, let rest):
            return .Cons(first, rest.append(other))
        }
    }

    func subsets() -> List<List<T>>{
        switch self {
        case .Empty:
            return .Cons(.Empty, .Empty)
        case .Cons(let first, let rest):
            // This next line is the real answer to the exercise: it is the closure that should replace
            // (??) in the original question. Everything else is Swift boilerplate!
            let addFirstElem: List<T> -> List<T> = { return .Cons(first, $0) }

            let subsetsWithoutFirstElem = rest.subsets()
            let subsetsWithFirstElem = subsetsWithoutFirstElem.map(addFirstElem)
            return subsetsWithoutFirstElem.append(subsetsWithFirstElem)
        }
    }
}
