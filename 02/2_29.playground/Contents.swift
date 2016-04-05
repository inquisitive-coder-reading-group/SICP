/*
 Exercise 2.29.  A binary mobile consists of two branches, 
 a left branch and a right branch. Each branch is a rod of 
 a certain length, from which hangs either a weight or another 
 binary mobile. We can represent a binary mobile using compound 
 data by constructing it from two branches (for example, using list):

 (define (make-mobile left right)
    (list left right))

 A branch is constructed from a length (which must be a number) together with a structure, which may be either a number (representing a simple weight) or another mobile:

 (define (make-branch length structure)
    (list length structure))


 */

enum List<T> {
    case Empty
    case Cons(T, T)
}

typealias Structure = Mobile

enum Mobile {
    case Weight(Int)
    indirect case Node(Mobile, Mobile)
}

struct Branch {

    let length: Int
    let structure: Structure

}

func makeMobile(left: Branch, right: Branch) -> Mobile {
    return Mobile.Node(left.structure, right.structure)
}

/*
    a.  Write the corresponding selectors left-branch and right-branch, which return the branches of a mobile, and branch-length and branch-structure, which return the components of a branch.
 */

extension Mobile {

    func leftBranch() -> Mobile {
        switch self {
            case .Weight(let weight):
                return Mobile.Weight(weight)
            case .Node(let left, _):
                return left
        }
    }

    func rightBranch() -> Mobile {
        switch self {
            case .Weight(let weight):
                return Mobile.Weight(weight)
            case .Node(_, let right):
                return right
        }
    }

}


/*
 b.  Using your selectors, define a procedure total-weight that returns the total weight of a mobile.
*/


extension Mobile {

    func totalWeight() -> Int {
        switch self {
            case .Weight(let weight):
                return weight
            case .Node(let left, let right):
                return left.totalWeight() + right.totalWeight()
        }
    }

}

/*
 Usage: 

    let m = Mobile.Node(Mobile.Node(Mobile.Empty, 3, Mobile.Empty), 34, Mobile.Empty)
    m.totalWeight() -> 37

 */

/*
 c.  A mobile is said to be balanced if the torque applied by its top-left branch is equal to that applied by its top-right branch (that is, if the length of the left rod multiplied by the weight hanging from that rod is equal to the corresponding product for the right side) and if each of the submobiles hanging off its branches is balanced. Design a predicate that tests whether a binary mobile is balanced.
*/

extension Mobile {

    func isBalanced() -> Bool {
        switch self {
            case .Weight(_):
                return false
            case .Node(let left, let right):
                return left.totalWeight() * left.length() == right.totalWeight() * right.length()
        }
    }

    func length() -> Int {

        switch self {
            case .Weight(let weight):
                return weight
            case .Node(let left, let right):
                let l = left.length()
                let r = right.length()
                return 1 + max(l, r)
        }

    }

}

/*
 Usage:
    let unbalanced = Mobile.Node(Mobile.Node(Mobile.Empty, 3, Mobile.Empty), 34, Mobile.Empty)
    unbalanced.isBalanced() -> false

    let balanced = Mobile.Node(Mobile.Node(Mobile.Empty, 32, Mobile.Empty), 0, Mobile.Node(Mobile.Node(Mobile.Empty, 8, Mobile.Empty), 0, Mobile.Node(Mobile.Empty, 8, Mobile.Empty)))
    balanced.isBalanced() -> true
*/

/*
 d.  Suppose we change the representation of mobiles so that the constructors are

 (define (make-mobile left right)
    (cons left right))

 (define (make-branch length structure)
    (cons length structure))

 How much do you need to change your programs to convert to the new representation?
 */
