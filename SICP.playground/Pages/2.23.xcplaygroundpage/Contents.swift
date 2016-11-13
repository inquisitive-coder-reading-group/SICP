/*
 Exercise 2.23.  The procedure for-each is similar to map. It takes as arguments a procedure and a list of elements. However, rather than forming a list of the results, for-each just applies the procedure to each of the elements in turn, from left to right. The values returned by applying the procedure to the elements are not used at all -- for-each is used with procedures that perform an action, such as printing. For example,

 (for-each (lambda (x) (newline) (display x))
 (list 57 321 88))
 57
 321
 88

 The value returned by the call to for-each (not illustrated above) can be something arbitrary, such as true. Give an implementation of for-each.
 */

enum List<T> {
    case empty
    indirect case cons(T, List<T>)
}

func forEach<T>(withTransform transform: (T) throws -> Bool, list: List<T>) -> Void {
    do {
        switch list {
        case .Empty:
            return
        case .Cons(let car, let cdr):
            try transform(car)
            forEach(withTransform: transform, list: cdr)
        }
    } catch {
        print("oh no, runtime error!")
    }
}


/*
 Usage:
 let list = List.Cons(1, List.Cons(2, List.Cons(3, List.Empty)))

 forEach(withTransform: { element in
 print(element)
 return true
 }, list: list)
 */
