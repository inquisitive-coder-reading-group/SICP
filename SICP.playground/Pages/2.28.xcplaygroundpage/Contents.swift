/*
 Exercise 2.28.  Write a procedure fringe that takes as argument a tree (represented as a list) and returns a list whose elements are all the leaves of the tree arranged in left-to-right order. For example,

 (define x (list (list 1 2) (list 3 4)))

 (fringe x)
 (1 2 3 4)

 (fringe (list x x))
 (1 2 3 4 1 2 3 4)
 */

import Foundation

enum Tree<T> {
    case Empty
    indirect case Node(Tree<T>, T, Tree<T>)
}

func fringe<T>(tree: Tree<T>) -> [T] {
    switch tree {
    case .Empty:
        return []
    case .Node(let left, let value, let right):
        let values: [T] = [value]
        return values + fringe(tree: left) + fringe(tree: right)
    }
}

/*
 Usage:

 let treeA = Tree.Node(Tree.Node(Tree.Empty, 2, Tree.Empty),
 1,
 Tree.Node(Tree.Empty, 3, Tree.Empty))
 let treeB = Tree.Node(Tree.Node(Tree.Empty, 5, Tree.Empty),
 4,
 Tree.Node(Tree.Empty, 6, Tree.Empty))

 let tree = Tree.Node(treeA, 0, treeB)


 fringe(tree)
 -> [0, 1, 2, 3, 4, 5, 6]
 */
