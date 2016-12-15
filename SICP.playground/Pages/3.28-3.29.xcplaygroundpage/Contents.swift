/*
 Exercise 3.28.  Define an or-gate as a primitive function box. Your or-gate constructor should be similar to and-gate.
 */

import XCTest

/*
 3.28
 */

precedencegroup infixGroup {
    associativity: left
}

infix operator <&&>: infixGroup
infix operator <||>: infixGroup
prefix operator <!>

// Logical AND

func <&&>(lhs: UInt8, rhs: UInt8) -> UInt8 {
    return lhs == 1 && rhs == 1 ? 1 : 0
}

// Logical OR

func <||>(lhs: UInt8, rhs: UInt8) -> UInt8 {
    return lhs == 1 || rhs == 1 ? 1 : 0
}

// Logical NOT

prefix func <!>(input: UInt8) -> UInt8 {
    return input == 1 ? 0 : 1
}


// Usage

XCTAssert((0 <&&> 0) == 0, "should evaluate to 0")

XCTAssert((0 <&&> 1) == 0, "should evaluate to 0")

XCTAssert((1 <&&> 1) == 1, "should evaluate to 1")

XCTAssert((0 <||> 0) == 0, "should evaluate to 0")

XCTAssert((0 <||> 1) == 1, "should evaluate to 1")

XCTAssert((1 <||> 1) == 1, "should evaluate to 1")

XCTAssert(<!>1 == 0, "should evaluate to 0")

XCTAssert(<!>0 == 1, "should evaluate to 1")


/*
 3.29
 */

typealias Bit = UInt8

class BitBox {
    var value: Bit
    init(value: Bit = 0) {
        self.value = value
    }
}

class BitOperation: BlockOperation {

    var bitBox: BitBox!

    convenience init(block: @escaping () -> Void, bitBox: BitBox) {
        self.init()
        addExecutionBlock(block)
        self.bitBox = bitBox
    }
    
}

struct FunctionBox {

    private var mainQueue = OperationQueue()

    init(withOperationQueue queue: OperationQueue) {
        mainQueue = queue
        mainQueue.maxConcurrentOperationCount = 1
    }

    @discardableResult mutating func addAction(dependentActions: [Operation] = [],
                                               input: BitOperation) -> BitOperation {
        dependentActions.forEach({ input.addDependency($0) })
        mainQueue.addOperation(input)
        return input
    }
    
    static func inverter(input: BitBox) -> BitOperation {
        return BitOperation(block: { self.invert(input: input) }, bitBox: input)
    }

    static private func invert(input: BitBox) {
        input.value = <!>input.value
    }

}

// Global Queue ensures that operations are executed synchronously
let globalTimeQueue = OperationQueue()

// Bitwise or consisting of 3 inverters and an AND gate
func or(a1: BitBox, a2: BitBox) -> BitOperation {

    var functionBox = FunctionBox(withOperationQueue: globalTimeQueue)

    let a1Inverter = FunctionBox.inverter(input: a1)
    let a2Inverter = FunctionBox.inverter(input: a2)

    functionBox.addAction(input: a1Inverter)
    functionBox.addAction(input: a2Inverter)

    var a3 = BitBox()

    let andAction: BitOperation = BitOperation(block: { a3 = BitBox(value: a1.value <&&> a2.value) })
    functionBox.addAction(dependentActions: [a1Inverter, a2Inverter], input: andAction)
    let a3Inverter = FunctionBox.inverter(input: a3)
    a3Inverter.addDependency(andAction)

    return a3Inverter
}



let test11 = or(a1: BitBox(value: 1), a2: BitBox(value: 1))
test11.completionBlock = { XCTAssert(test11.bitBox.value == 1, "Bitwise or of 11 == 1") }
let test01 = or(a1: BitBox(value: 0), a2: BitBox(value: 1))
test01.completionBlock = { XCTAssert(test01.bitBox.value == 1, "Bitwise or of 01 == 1") }
let test10 = or(a1: BitBox(value: 1), a2: BitBox(value: 0))
test10.completionBlock = { XCTAssert(test10.bitBox.value == 1, "Bitwise or of 10 == 1") }
let test00 = or(a1: BitBox(value: 0), a2: BitBox(value: 0))
test00.completionBlock = { XCTAssert(test00.bitBox.value == 0, "Bitwise or of 00 == 0") }

globalTimeQueue.addOperation(test11)
globalTimeQueue.addOperation(test01)
globalTimeQueue.addOperation(test10)
globalTimeQueue.addOperation(test00)
