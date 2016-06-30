/*
Exercise 1.11.  A function f is defined by the rule that f(n) = n if n<3 and f(n) = f(n - 1) + 2f(n - 2) + 3f(n - 3) if n is greater than or equal to 3. Write a procedure that computes f by means of a recursive process. Write a procedure that computes f by means of an iterative process.
*/

// RECURSIVE

func fRecursive(n: Int) -> Int {
    switch n {
        case n where n < 3:
            return n
        default:
            return fRecursive(n - 1) +
                2 * fRecursive(n - 2) +
                3 * fRecursive(n - 3)
    }
}

// ITERATIVE

func fIterative(n: Int, i: Int, j: Int, count: Int) -> Int {
    if count == 0 {
        return n
    }
    else {
        return fIterative(i, i: j, j: (j + 2 * i + 3 * n), count: count - 1)
    }
}

fRecursive(6)
fIterative(0, i: 1, j: 2, count: 6)
