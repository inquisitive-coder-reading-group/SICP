/* Exercise 2.31:
 
 Abstract your answer to Exercise 2.30 to produce a procedure tree-map with the property that square-tree could be defined as
 (define (square-tree tree) (tree-map square tree)) */

enum Tree<T> {
    case Leaf(T)
    case Node(children: [Tree<T>])
    
    func map<U>(transform: T -> U) -> Tree<U> {
        switch self {
        case .Leaf(let v):
            return .Leaf(transform(v))
        case .Node(let children):
            let mappedChildren = children.map { $0.map(transform) }
            return .Node(children: mappedChildren)
        }
    }
}

/* Example:
 
 (list 1
 (list 2 (list 3 4) 5)
 (list 6 7))) */

let exampleTree: Tree<Int> =
    .Node(children: [.Leaf(1),
    .Node(children: [.Leaf(2),
        .Node(children: [.Leaf(3), .Leaf(4)]), .Leaf(5)]),
    .Node(children: [.Leaf(6), .Leaf(7)])])

let squaredTree = exampleTree.map({$0 * $0})

String(squaredTree)

