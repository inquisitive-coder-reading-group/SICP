/*
 Exercise 2.30.  Define a procedure square-tree analogous to the square-list procedure of exercise 2.21. That is, square-list should behave as follows:

 (square-tree
    (list 1
        (list 2 (list 3 4) 5)
        (list 6 7)))

 
 --> (1 (4 (9 16) 25) (36 49))

 Define square-tree both directly (i.e., without using any higher-order procedures) and also by using map and recursion.
 */

enum List<T> {
    case Value(T)
    indirect case Cons(List<T>, List<T>)
}

let list1 = List.Cons(List.Value(1),
                      List.Cons(List.Cons(List.Cons(List.Value(2), List.Cons(List.Value(3), List.Value(3))), List.Value(5)),
                        List.Cons(List.Value(6), List.Value(7))))

//func squareTree() -> List<Int, List<Int, List<Int, Int>>> {
//    return List.Empty
//}
//
//func squareTreeIndirect() -> List<Int, List<Int, List<Int, Int>>> {
//    return List.Empty
//}
