/*
 Exercise 2.59.  Implement the union-set operation for the unordered-list representation of sets.
 */


enum SetAsUnorderedList<T: Equatable> {
    case empty
    indirect case cons(T, SetAsUnorderedList<T>)

    func append(_ element: T) -> SetAsUnorderedList<T> {
        return contains(element) ? self : SetAsUnorderedList.cons(element, self)
    }

    func contains(_ element: T) -> Bool {
        switch self {
        case .empty:
            return false
        case .cons(let car, let cdr):
            return element == car ? true : cdr.contains(element)
        }
    }

}



func unionSet<T>(_ set1: SetAsUnorderedList<T>,
              set2: SetAsUnorderedList<T>) -> SetAsUnorderedList<T> {
    switch (set1, set2) {

    // BASE CASE: one or both sets is empty
    case (_, SetAsUnorderedList.empty):
        return set1

    default:

        // RECURSIVE CASE: niether set is empty

        switch set2 {
        case .empty:
            return set1
        case .cons(let car, let cdr):
            return unionSet(set1.append(car), set2: cdr)
        }
    }
}

/// Example:

let set1 = SetAsUnorderedList.cons(4,
                                   SetAsUnorderedList.cons(54,
                                    SetAsUnorderedList.cons(55,
                                        SetAsUnorderedList.empty)))
let set2 = SetAsUnorderedList.cons(1,
                                   SetAsUnorderedList.cons(57,
                                    SetAsUnorderedList.cons(55,
                                        SetAsUnorderedList.empty)))

unionSet(set1, set2: set2)
