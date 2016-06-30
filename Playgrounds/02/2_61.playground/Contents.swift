/*
 Exercise 2.61.  Give an implementation of adjoin-set using the ordered representation. By analogy with element-of-set? show how to take advantage of the ordering to produce a procedure that requires on the average about half as many steps as with the unordered representation.
 */

enum SetAsOrderedList<T: Comparable> {
    case Empty
    indirect case Cons(T, SetAsOrderedList)


    // One advantage of ordering shows up in element-of-set?: 
    // In checking for the presence of an item, we no longer have 
    // to scan the entire set. If we reach a set element that is 
    // larger than the item we are looking for, then we know that 
    // the item is not in the set:
    func elementOfSet(element: T) -> Bool {
        switch self {
        case .Empty:
            return false
        case .Cons(let car, let cdr):
            switch element == car {
            case true:
                return true
            case false:
                return element < car ? false : cdr.elementOfSet(element)
            }
        }
    }


    func intersectionWithSet(otherSet: SetAsOrderedList<T>) -> SetAsOrderedList<T> {
        switch self {
        case .Empty:
            // if either set is empty, then then the intersection of the 2 sets is also empty
            return .Empty
        case .Cons(let car, let cdr):
            switch otherSet {
            // if either set is empty, then then the intersection of the 2 sets is also empty
            case .Empty:
                return .Empty
            case .Cons(let _car, let _cdr):
                // if the 2 elements are equal, that gives us the intersection, and the rest of the 
                // intersection is the intersection of the cdrs of the 2 sets
                // Otherwise, if this set's car is less than otherset's car, we return the intersection of
                // this set's cdr with all of the otherSet; alternatively, if this set's car is greater than
                // the otherSet's cdr, we return the intersection of this set with the otherSet's cdr
                guard car == _car else  {
                    return car < _car ? cdr.intersectionWithSet(otherSet) : intersectionWithSet(_cdr)
                }
                return cdr.intersectionWithSet(_cdr)
            }
        }

    }

    func adjoinSet(element: T) -> SetAsOrderedList<T> {
        switch self {
        case .Empty:
            // if the set is empty, we just push the new element onto the end of the set
            return .Cons(element, self)
        case .Cons(let car, let cdr):
            // if the element is equal to car of the set, this is where we push the new element onto the set
            guard element == car else {
                return element < car ? .Cons(element, self) : .Cons(car, cdr.adjoinSet(element))
            }
            return self
        }
    }

}
