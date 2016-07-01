/* Exercise 2.29:
 A binary mobile consists of two branches, a left branch and a right branch. Each branch
 is a rod of a certain length, from which hangs either a weight or another binary
 mobile. We can represent a binary mobile using compound data by constructing it from
 two branches (for example, using list):

 (define (make-mobile left right) (list left right))

 A branch is constructed from a length (which must be a number) together with a
 structure, which may be either a number (representing a simple weight) or another
 mobile:

 (define (make-branch length structure) (list length structure)) */


/* Commentary:
 There are three types of things in this problem: Mobiles, Branches, and Structures.
 The top-level type is the Mobile; the other two only come up in the context of
 dealing with Mobiles. In Swift, it makes sense to define Mobile as a type, and
 give it two namespaced types, Mobile.Branch and Mobile.Structure, for use internally.

 The Mobile type itself is a product type: it is simply two branches. We could store
 this in Swift as a (potentially labeled) tuple:

 typealias Mobile = (left: Branch, right: Branch)

 but I prefer structs, because it allows us to define the type Branch inside the Mobile
 namespace:

 struct Mobile {
 let left: Branch
 let right: Branch
 ...
 }

 The Branch type is similarly simple, consisting of two fields, one of type Int and
 one of type Structure. Branch and Mobile are so similar, in fact, that in Scheme,
 they take the exact same form; a two-element list. In Swift, we use two-element
 structs.

 Finally, a Structure may be *either* an Int (weight) or a Mobile (submobile). In
 Scheme, which is not strongly typed, a simple untyped variable will do; at runtime,
 you can check whether the variable is a number or not using the (number? ...)
 predicate (if it is, you know it's a weight, and otherwise, it's a Mobile). In
 Swift, this won't fly. Instead, we use an enum with two cases: .Weight (with which
 we associate an Int representing the Mobile's weight), and .SubMobile (with which
 we associate a SubMobile). Because Structures are stored inside Branches which
 are stored inside Mobiles, this creates a mutually recursive loop (a Mobile
 can contain a Branch, which can contain a Structure, which can contain another Mobile,
 which can contain a Branch, which can contain another Structure, which can
 contain another Mobile...), which in Swift requires us to enable indirection
 with the indirect keyword.

 All together, our type looks like this: */

struct Mobile {
    struct Branch {
        let length: Int
        let structure: Structure
    }

    enum Structure {
        case Weight(Int)
        indirect case SubMobile(Mobile)
    }

    let left: Branch
    let right: Branch
}

let balancedMobile1 = Mobile(left: Mobile.Branch(length: 5, structure: .Weight(8)),
                             right: Mobile.Branch(length: 10, structure: .Weight(4)))

let balancedMobile2 = Mobile(left: Mobile.Branch(length: 1, structure: .SubMobile(balancedMobile1)),
                             right: Mobile.Branch(length: 4, structure: .Weight(3)))


/* It is perhaps also worth considering another version of this data structure,
 which collapses the three types into one: an enum. Unlike Mobile, MobileV2
 is allowed to be a single weight, unattached to a branch. */

enum MobileV2 {
    case Weight(Int)
    indirect case Node(left: MobileV2, leftLength: Int, right: MobileV2, rightLength: Int)
}

let balancedMobile1V2 = MobileV2.Node(left: .Weight(8), leftLength: 5, right: .Weight(4), rightLength: 10)

let balancedMobile2V2 = MobileV2.Node(left: balancedMobile1V2, leftLength: 1, right: .Weight(3), rightLength: 4)

/* Below, we continue to develop MobileV2, so that we can see how it compares to the
 more literal translation of the book. */


/* (a) Write the corresponding selectors left-branch and right-branch, which return the branches of a mobile, and branch-length and branch-structure, which re- turn the components of a branch. */

/* Commentary: These are kind of silly to write in Swift, because we can just use
 dot-notation to directly access these members.
 (e.g. myMobile.left, instead of myMobile.leftBranch())
 Nonetheless, here they are, in extensions on the types:
 */

extension Mobile {
    func leftBranch() -> Branch { return left }
    func rightBranch() -> Branch { return right }
}

extension Mobile.Branch {
    func branchLength() -> Int { return length }
    func branchStructure() -> Mobile.Structure { return structure }
}

balancedMobile1.leftBranch().branchLength()

/* It is unnecessary to translate this for MobileV2, which does not have
 the concept of a branch or structure. But we can write some basic
 accessors. They require quite a bit of boilerplate... point 1 against MobileV2. */

extension MobileV2 {
    func leftBranchLength() -> Int? {
        switch self {
        case .Node(left: _, leftLength: let l, right: _, rightLength: _):
            return l
        case .Weight(_):
            return nil
        }
    }

    func rightBranchLength() -> Int? {
        switch self {
        case .Node(left: _, leftLength: _, right: _, rightLength: let l):
            return l
        case .Weight(_):
            return nil
        }
    }

    func leftSubMobile() -> MobileV2? {
        switch self {
        case .Node(left: let m, leftLength: _, right: _, rightLength: _):
            return m
        case .Weight(_):
            return nil
        }
    }

    func rightSubMobile() -> MobileV2? {
        switch self {
        case .Node(left: _, leftLength: _, right: let m, rightLength: _):
            return m
        case .Weight(_):
            return nil
        }
    }

    func isWeight() -> Bool {
        if case .Weight(_) = self {
            return true
        } else {
            return false
        }
    }
}

balancedMobile1V2.leftBranchLength()


/* (b) Using your selectors, define a procedure total-weight that returns the total
 weight of a mobile. */

/* Commentary: Because we're dealing with mutually recursive data types, Structure
 and Mobile, it makes sense to write mutually recursive procedures. We define one
 weight function for Structures, and one for Mobiles -- the two functions call
 each other as necessary. */

extension Mobile.Structure {
    func totalWeight() -> Int {
        switch self {
        case .Weight(let w):
            return w
        case .SubMobile(let m):
            return m.totalWeight()
        }
    }
}

extension Mobile {
    func totalWeight() -> Int {
        return left.structure.totalWeight() + right.structure.totalWeight()
    }
}

balancedMobile1.totalWeight() // 8 + 4 = 12
balancedMobile2.totalWeight() // 12 + 3 = 15


/* Because the data structure is simpler, it's easier to write a simple recursive
 function for MobileV2: */

extension MobileV2 {
    func totalWeight() -> Int {
        switch self {
        case .Weight(let w):
            return w
        case .Node(left: let l, leftLength: _, right: let r, rightLength: _):
            return l.totalWeight() + r.totalWeight()
        }
    }
}

balancedMobile1V2.totalWeight()
balancedMobile2V2.totalWeight()


/* (c) A mobile is said to be balanced if the torque applied by its top-left branch is equal to that applied by its top-right branch (that is, if the length of the left rod multiplied by the weight hanging from that rod is equal to the corresponding product for the right side) and if each of the submobiles hanging off its branches is balanced. Design a predicate that tests whether a binary mobile is balanced. */

/* Commentary: Again, we design this procedure by obeying the structure of our
 (mutually recursive) data. */

extension Mobile.Structure {
    func isBalanced() -> Bool {
        switch self {
        // A single weight, having no left or right branch, is always balanced
        case .Weight(_):
            return true
        case .SubMobile(let m):
            return m.isBalanced()
        }
    }
}

extension Mobile {
    func leftTorque() -> Int {
        return left.length * left.structure.totalWeight()
    }

    func rightTorque() -> Int {
        return right.length * right.structure.totalWeight()
    }

    func isBalanced() -> Bool {
        return (rightTorque() == leftTorque()) && left.structure.isBalanced() && right.structure.isBalanced()
    }
}

balancedMobile1.leftTorque() // 5 * 8
balancedMobile1.rightTorque() // 10 * 4
balancedMobile1.isBalanced()

balancedMobile2.leftTorque() // 12 * 1
balancedMobile2.rightTorque() // 4 * 3
balancedMobile2.isBalanced()


/* As with totalWeight, the simple recursive enum makes this function easy, too. */

extension MobileV2 {
    func leftTorque() -> Int? {
        guard let leftLen = leftBranchLength(),
            left = leftSubMobile() else { return nil }
        return left.totalWeight() * leftLen
    }

    func rightTorque() -> Int? {
        guard let rightLen = rightBranchLength(),
            right = rightSubMobile() else { return nil }
        return right.totalWeight() * rightLen
    }

    func isBalanced() -> Bool {
        // If we don't have a left/right submobile, we are balanced by default
        guard let left = leftSubMobile(), right = rightSubMobile() else { return true }
        return leftTorque() == rightTorque() && left.isBalanced() && right.isBalanced()
    }
}

balancedMobile1V2.leftTorque() // 5 * 8
balancedMobile1V2.rightTorque() // 10 * 4
balancedMobile1V2.isBalanced()

balancedMobile2V2.leftTorque() // 12 * 1
balancedMobile2V2.rightTorque() // 4 * 3
balancedMobile2V2.isBalanced()


/* (d) Suppose we change the representation of mobiles so that the constructors are

 (define (make-mobile left right) (cons left right))
 (define (make-branch length structure)
 (cons length structure))

 How much do you need to change your programs to
 convert to the new representation? */

/* Commentary: not much. We simply update our accessors, left-branch (now car),
 right-branch (now cdr), branch-length (now car), and branch-structure (now cdr).
 Everything else relies on those accessors, and otherwise is not dependent on the
 representation in memory of branches and mobiles.

 To get at this in Swift, we could imagine changing our implementation of mobile and branch to be Tuples instead of Structs:

 typealias Mobile = (left: Branch, right: Branch)
 typealias Branch = (length: Int, structure: Structure)

 This would require pretty much no other changes in our code.
 */
