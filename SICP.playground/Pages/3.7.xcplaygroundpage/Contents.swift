//: [Previous](@previous)

import Foundation

/*
 Exercise 3.7.  Consider the bank account objects created by make-account, with the password modification described in exercise 3.3. Suppose that our banking system requires the ability to make joint accounts. Define a procedure make-joint that accomplishes this. Make-joint should take three arguments. The first is a password-protected account. The second argument must match the password with which the account was defined in order for the make-joint operation to proceed. The third argument is a new password. Make-joint is to create an additional access to the original account using the new password. For example, if peter-acc is a bank account with password open-sesame, then

 (define paul-acc
 (make-joint peter-acc 'open-sesame 'rosebud))

 will allow one to make transactions on peter-acc using the name paul-acc and the password rosebud. You may wish to modify your solution to exercise 3.3 to accommodate this new feature.
 */

struct Account {
    let password: String
}

typealias Amount = Int
typealias Message = String

enum ErrorType: Error {
    case msg, pw, insufficientFunds, args
}

struct MakeAccount {

    private var balance: Amount
    private (set) var password: String

    init(balance: Amount, password: String) {
        self.balance = balance
        self.password = password
    }
    
    private mutating func withdraw(amount: Amount) throws {
        if balance >= amount {
            balance = balance - amount
        }
        else {
            throw ErrorType.insufficientFunds
        }
    }

    private mutating func deposit(amount: Amount) {
        balance = balance + amount
    }

    mutating func dispatch(message: Message) throws {
        switch message {
        case _ where message.contains("withdraw"):
            let arg = message.components(separatedBy: .whitespaces).last
            do {
                let amount = try int(fromString: arg)
                try withdraw(amount: amount)
            }
            catch ErrorType.insufficientFunds {
                print("You do not have sufficient funds")
            }
            catch {
                print("You must pass in an amount")
            }
        case _ where message.contains("deposit"):
            let arg = message.components(separatedBy: .whitespaces).last
            do {
                let amount = try int(fromString: arg)
                deposit(amount: amount)
            }
            catch {
                print("You must pass in an amount")
            }
        default:
            throw ErrorType.msg
        }
    }

    private func int(fromString: String?) throws -> Int {
        guard fromString != nil else {
            throw ErrorType.args
        }
        return Int(fromString!)!
    }

    mutating func performAction(password: String, message: Message) throws {
        if password == password {
            do {
                try dispatch(message: message)
            }
            catch {
                throw ErrorType.msg
            }
        }
        else {
            throw ErrorType.pw
        }
    }

}

func makeJoint(oldPassword: String, jointPassword: String) -> ((String, Message, inout MakeAccount) throws -> ()) {

    return {(key: String, message: Message, account: inout MakeAccount ) in
        if key != jointPassword {
            throw ErrorType.pw
        }
        else {
            switch message {
            case _ where message.contains("withdraw"),
                 _ where message.contains("deposit"):
                do {
                    try account.dispatch(message: message)
                }
                catch {
                    throw ErrorType.msg
                }
            default:
                throw ErrorType.msg
            }
        }
    }
}


var account = MakeAccount(balance: 50, password: "Password1")

do {
    try account.performAction(password: "Password1", message: "withdraw 10") // => $40
}
catch {
    print("Error: \(error)")
}

do {
    try account.performAction(password: "Password1", message: "deposit 30") // => $70
}
catch {
    print("Error: \(error)")
}

var account2 = makeJoint(oldPassword: "Password1", jointPassword: "Password2")

do {
    try account2("Password2", "withdraw 10", &account) // => $60
}
catch {
    print("Error: \(error)")
}

do {
    try account.performAction(password: "Password1", message: "withdraw 10") // => $50
}
catch {
    print("Error: \(error)")
}
