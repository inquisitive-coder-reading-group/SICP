import Foundation

protocol Number: IntegerLiteralConvertible {
    
    func add(n: Self) -> Self
    func multiplyBy(n: Self) -> Self
    func divideBy(n: Self) -> Self
    
}

extension Number {
    
    func subtract(n: Self) -> Self {
        return add(n.multiplyBy(-1))
    }
    
}

extension Double: Number {
    
    func add(n: Double) -> Double {
        return self + n
    }
    
    func multiplyBy(n: Double) -> Double {
        return self * n
    }
    
    func divideBy(n: Double) -> Double {
        return self / n
    }
    
}

let double1: Double = 1.5
let double2: Double = 7.2

double1.add(double2)
double1.subtract(double2)
double1.multiplyBy(double2)
double1.divideBy(double2)

struct RationalNumber {
    
    let numerator: Int
    let denominator: Int
    
    init(numerator: Int, denominator: Int) {
        let gcd = RationalNumber.greatestCommonDenominator(numerator, denominator)
        
        let n: Int
        if numerator < 0 && denominator < 0 {
            n = abs(numerator)
        }
        else if denominator < 0 {
            n = -numerator
        }
        else {
            n = numerator
        }
        
        let d = abs(denominator)
        
        self.numerator = n / gcd
        self.denominator = d / gcd
    }
    
    private static func greatestCommonDenominator(x: Int, _ y: Int) -> Int {
        if y == 0 {
            return abs(x)
        }
        else {
            return greatestCommonDenominator(y, x % y)
        }
    }
    
}

extension RationalNumber: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "\(numerator)/\(denominator)"
    }
    
}

extension RationalNumber: IntegerLiteralConvertible {
    
    init(integerLiteral value: Int) {
        numerator = value
        denominator = 1
    }
    
}

extension RationalNumber: Number {
    
    func add(n: RationalNumber) -> RationalNumber {
        let newDenominator = denominator * n.denominator
        let n1 = numerator * n.denominator
        let n2 = n.numerator * denominator
        
        return RationalNumber(numerator: n1 + n2, denominator: newDenominator)
    }
    
    func multiplyBy(n: RationalNumber) -> RationalNumber {
        return RationalNumber(numerator: numerator * n.numerator, denominator: denominator * n.denominator)
    }
    
    func divideBy(n: RationalNumber) -> RationalNumber {
        return RationalNumber(numerator: numerator * n.denominator, denominator: denominator * n.numerator)
    }
    
}

let rational1 = RationalNumber(numerator: 7, denominator: 8)
let rational2 = RationalNumber(numerator: 1, denominator: 2)

rational1.add(rational2)
rational1.multiplyBy(rational2)
rational1.subtract(rational2)

struct ComplexNumber {
    
    let real: Double
    let imaginary: Double
    
    init(real: Double, imaginary: Double) {
        self.real = real
        self.imaginary = imaginary
    }
    
    init(magnitude: Double, angle: Double) {
        real = cos(angle) * magnitude
        imaginary = sin(angle) * magnitude
    }
    
    var magnitude: Double {
        return sqrt(real * real + imaginary * imaginary)
    }
    
    var angle: Double {
        return atan2(imaginary, real)
    }
    
}

extension ComplexNumber: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "\(real) + \(imaginary)i"
    }
    
}

extension ComplexNumber: IntegerLiteralConvertible {
    
    init(integerLiteral value: Int) {
        real = Double(value)
        imaginary = 0
    }
    
}

extension ComplexNumber: Number {
    
    func add(n: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(real: real + n.real, imaginary: imaginary + n.imaginary)
    }
    
    func subtract(n: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(real: real - n.real, imaginary: imaginary - n.imaginary)
    }
    
    func multiplyBy(n: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(magnitude: magnitude * n.magnitude, angle: angle + n.angle)
    }
    
    func divideBy(n: ComplexNumber) -> ComplexNumber {
        return ComplexNumber(magnitude: magnitude / n.magnitude, angle: angle - n.angle)
    }
    
}

let complex1 = ComplexNumber(real: 3, imaginary: 4)
let complex2 = ComplexNumber(magnitude: complex1.magnitude, angle: complex1.angle)

complex1.add(complex2)
complex1.subtract(complex1)
complex1.multiplyBy(complex1)
complex1.divideBy(complex1)

/* Exercise 2.79
   Define a generic equality predicate equ? that tests the equality of two numbers, and install it in the generic arithmetic package. This operation should work for ordinary numbers, rational numbers, and complex numbers.
*/

extension RationalNumber: Equatable {}

func ==(lhs: RationalNumber, rhs: RationalNumber) -> Bool {
    return lhs.numerator == rhs.numerator && lhs.denominator == rhs.denominator
}

RationalNumber(numerator: 1, denominator: 2) == RationalNumber(numerator: 1, denominator: 2)
RationalNumber(numerator: 1, denominator: 2) == RationalNumber(numerator: 3, denominator: 4)

extension ComplexNumber: Equatable {}

func ==(lhs: ComplexNumber, rhs: ComplexNumber) -> Bool {
    return lhs.real == rhs.real && lhs.imaginary == rhs.imaginary
}

ComplexNumber(real: 1, imaginary: 2) == ComplexNumber(real: 1, imaginary: 2)
ComplexNumber(real: 1, imaginary: 2) == ComplexNumber(real: 3, imaginary: 4)

/* Exercise 2.80
   Define a generic predicate =zero? that tests if its argument is zero, and install it in the generic arithmetic package. This operation should work for ordinary numbers, rational numbers, and complex numbers.
 */

protocol IsZero: IntegerLiteralConvertible, Equatable {
}

extension IsZero {
    func isZero() -> Bool {
        return self == 0
    }
}

extension Double: IsZero {}

let zeroDouble: Double = 0
zeroDouble.isZero()

let nonZeroDouble: Double = 1
nonZeroDouble.isZero()

extension RationalNumber: IsZero {}

RationalNumber(numerator: 0, denominator: 4).isZero()
RationalNumber(numerator: 1, denominator: 4).isZero()

extension ComplexNumber: IsZero {}

ComplexNumber(real: 0, imaginary: 0).isZero()
ComplexNumber(real: 1, imaginary: 0).isZero()
ComplexNumber(real: 0, imaginary: 1).isZero()
