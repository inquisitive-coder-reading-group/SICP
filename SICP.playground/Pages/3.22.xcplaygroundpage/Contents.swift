//: [Previous](@previous)

import Foundation

/*
 Exercise 3.22.  Instead of representing a queue as a pair of pointers, we can build a queue as a procedure with local state. The local state will consist of pointers to the beginning and the end of an ordinary list. Thus, the make-queue procedure will have the form
 (define (make-queue)
    (let ((front-ptr ...)
         (rear-ptr ...))
        <definitions of internal procedures>
        (define (dispatch m) ...)
        dispatch))
 */

enum QueueError: Error {
    case general
}



/// List Data Structure
///
/// - empty: denotes the end of the list
enum List<T> {
    case empty
    indirect case cons(T, List<T>)

}


// MARK: - Decomposable (extend list with a couple of computed properties for introspection)

extension List: Decomposable {

    typealias String = T

    init(withElement element: T?) {
        self = element != nil ? .cons(element!, .empty) : .empty
    }

    var car: T? {
        switch self {
        case .empty:
            return nil
        case .cons(let car, _):
            return car
        }
    }

    var cdr: List<T>? {
        switch self {
        case .empty:
            return nil
        case .cons(_, let cdr):
            return cdr
        }
    }

}

protocol Decomposable {

    associatedtype T

    init(withElement element: T?)
    
    var car: T? { get }
    var cdr: List<T>? { get }

}

struct Queue<Element: Decomposable> {

    private var isEmpty: Bool {
        return frontPtr == nil
    }
    private (set) var frontPtr: Element?
    private (set) var rearPtr: Element?
    private mutating func insert(element: Element) {
        if isEmpty {
            frontPtr = element
        }
        rearPtr = element
    }
    private mutating func delete() {
        guard !isEmpty, let frontPointer = frontPtr?.cdr as? Element else {
            return
        }
        frontPtr = frontPointer
    }
    mutating func dispatch(message: String) throws -> Any? {
        switch message {
        case let m where m == "isEmpty":
            return isEmpty
        case let m where m == "frontPtr":
            return frontPtr
        case let m  where m.contains("insert"):
            let element = m.components(separatedBy: "insert ")[1]

            if let element = element as? Element.T {
                let newElement = Element(withElement: element)
                return insert(element: newElement)
            }
            else {
                throw QueueError.general
            }
        case let m  where m == "delete":
            return delete()
        default:
            throw QueueError.general
        }

    }
}

var emptyQueue = Queue<List<String>>()

do {
    try emptyQueue.dispatch(message: "isEmpty") // true
}
catch {
    print("error: \(error)")
}

var queueOfLength1 = Queue<List<String>>()
do {
    try queueOfLength1.dispatch(message: "insert a")

    // FRONT AND REAR POINTERS ARE EQUAL AFTER FIRST INSERTION

    queueOfLength1.frontPtr // cons("a", List<Swift.String>.empty)
    queueOfLength1.rearPtr  // cons("a", List<Swift.String>.empty)
}
catch {
    print("error: \(error)")
}

do {

    // Insert an additional element into queueOfLength1
    
    try queueOfLength1.dispatch(message: "insert b")

    var queueOfLength2 = queueOfLength1

    // FRONT AND REAR POINTERS ARE NOT EQUAL AFTER FIRST INSERTION

    queueOfLength2.frontPtr  // cons("a", List<Swift.String>.empty)
    queueOfLength2.rearPtr   // cons("b", List<Swift.String>.empty)

}
catch {
    print("error \(error)")
}

do {
    // Delete an element from queueOfLength1

    try queueOfLength1.dispatch(message: "delete")

    queueOfLength1.frontPtr // .empty
}
catch {
    print("error \(error)")
}
