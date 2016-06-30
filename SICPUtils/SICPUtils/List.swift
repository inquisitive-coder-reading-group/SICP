//
//  List.swift
//  SICPUtils
//
//  Created by Matthew Buckley on 4/13/16.
//  Copyright © 2016 Swift Book Club. All rights reserved.
//

public enum List<T> {

    case Empty
    indirect case Cons(T, List<T>)

    func decompose() -> (T, List<T>)? {
        switch self {
        case .Empty:
            return nil
        case .Cons(let car, let cdr):
            return (car, cdr)
        }
    }

    // example of a function on lists:
    func map<U>(transform: T -> U) -> List<U> {
        // If the original list (self) is empty, then we can't decompose it, and we return the empty list
        // (because mapping a transform onto an empty list is still the empty list)
        guard let (car, cdr) = decompose() else { return .Empty }

        // Now we can use car and cdr to refer to the first element of the list and the rest of the list, like in Scheme
        return .Cons(transform(car), cdr.map(transform))
    }

}
