/*
Exercise 2.59.  Implement the union-set operation for the unordered-list representation of sets.
 */


enum SetAsUnorderedList<T: Equatable> {
    case Empty
    indirect case Cons(T, SetAsUnorderedList<T>)

    func append(element: T) -> SetAsUnorderedList<T> {
        return contains(element) ? self : SetAsUnorderedList.Cons(element, self)
    }

    func contains(element: T) -> Bool {
        switch self {
            case .Empty:
                return false
            case .Cons(let car, let cdr):
                return element == car ? true : cdr.contains(element)
            }
    }

}



func unionSet<T>(set1: SetAsUnorderedList<T>,
              set2: SetAsUnorderedList<T>) -> SetAsUnorderedList<T> {
    switch (set1, set2) {

        // BASE CASE: one or both sets is empty
        case (_, SetAsUnorderedList.Empty):
            return set1

        default:

            // RECURSIVE CASE: niether set is empty

            switch set2 {
            case .Empty:
                return set1
            case .Cons(let car, let cdr):
                return unionSet(set1.append(car), set2: cdr)
        }
    }
}

/// Example:

let set1 = SetAsUnorderedList.Cons(4,
                                   SetAsUnorderedList.Cons(54,
                                    SetAsUnorderedList.Cons(55,
                                        SetAsUnorderedList.Empty)))
let set2 = SetAsUnorderedList.Cons(1,
                                   SetAsUnorderedList.Cons(57,
                                    SetAsUnorderedList.Cons(55,
                                        SetAsUnorderedList.Empty)))

unionSet(set1, set2: set2)

