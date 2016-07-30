/*
    Exercise 2.60.  We specified that a set would be represented as a list with no duplicates. Now suppose we allow duplicates. For instance, the set {1,2,3} could be represented as the list (2 3 2 1 3 2 2). Design procedures element-of-set?, adjoin-set, union-set, and intersection-set that operate on this representation. How does the efficiency of each compare with the corresponding procedure for the non-duplicate representation? Are there applications for which you would use this representation in preference to the non-duplicate one?
 */

/*
 TIME EFFICIENCY:
 - elementOfSet: O(n)
 - adjoinSet: O(1) --> more efficient than non-duplicate implementation
 - unionSet: O(n^2)
 - intersectionSet: O(n^2)

 */

enum SetWithDuplicates<T: Equatable> {
    case Empty
    indirect case Cons(T, SetWithDuplicates<T>)
}

extension SetWithDuplicates {

    func elementOfSet(element: T) -> Bool {
        switch self {
        case .Empty:
            return false
        case .Cons(let car, let cdr):
            if element == car {
                return true
            }
            else {
                return cdr.elementOfSet(element)
            }
        }
    }

    func adjoinSet(element: T) -> SetWithDuplicates {
        return .Cons(element, self)
    }

    func unionSet(otherSet: SetWithDuplicates<T>) -> SetWithDuplicates {
        switch self {
        case .Empty:
            return otherSet
        case .Cons(_, _):
            switch otherSet {
            case .Empty:
                return self
            case .Cons(let car, let cdr):
                return .Cons(car, unionSet(cdr))
            }
        }
    }

    func intersectionSet(withOtherSet otherSet: SetWithDuplicates) -> SetWithDuplicates {
        switch (self, otherSet) {
        case (.Cons(_, _), .Cons(let car, let cdr)):
            return elementOfSet(car) ? .Cons(car, intersectionSet(withOtherSet: cdr)) : intersectionSet(withOtherSet: cdr)
        default:
            return .Empty
        }
    }
    
}

// [4, 5, 5]
let test = SetWithDuplicates.Cons(4, SetWithDuplicates.Cons(5, SetWithDuplicates.Cons(5, SetWithDuplicates.Empty)))

// [8, 10]
let test2 = SetWithDuplicates.Cons(8, SetWithDuplicates.Cons(10, SetWithDuplicates.Empty))

// [8, 4]
let test3 = SetWithDuplicates.Cons(8, SetWithDuplicates.Cons(4, SetWithDuplicates.Empty))

// true
test.elementOfSet(4)

// [6, 4, 5, 5]
test.adjoinSet(6)

// [8, 10, 4, 5, 5]
test.unionSet(test2)

// [4]
test.intersectionSet(withOtherSet: test3)
