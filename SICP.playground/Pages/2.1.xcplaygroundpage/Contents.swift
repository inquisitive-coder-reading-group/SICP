/*
 Exercise 2.1.  Define a better version of make-rat that handles both positive and negative arguments. Make-rat should normalize the sign so that if the rational number is positive, both the numerator and denominator are positive, and if the rational number is negative, only the numerator is negative.
 */

struct Cons<T> {
    var car: T
    var cdr: T

    init(car: T, cdr: T) {
        self.car = car
        self.cdr = cdr
    }

}

func numer<T>(_ x: Cons<T>) -> T { return x.car }

func denom<T>(_ x: Cons<T>) -> T { return x.cdr }

func printRat<T>(_ x: Cons<T>) -> Void {
    print("\n")
    print("\(numer(x))")
    print("/")
    print("\(denom(x))")
}

func gcd(_ x: Cons<Int>) -> Int {
    if x.cdr == 0 {
        return x.car
    }
    return gcd(Cons(car: x.cdr, cdr: x.car % x.cdr))
}

func makeRat(_ n: Int, d: Int) -> Cons<Int> {

    let g = gcd(Cons(car: n, cdr: d))

    return Cons(car: (n / g), cdr: (d / g))
}
