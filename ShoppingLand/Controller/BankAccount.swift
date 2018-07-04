//
//  BankAccount.swift
//  ShoppingLand
//
//  Created by Florentin Lupascu on 04/07/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import Foundation

class BankAccount {
    
    private init() {}
    static let bankAccountKey = "Bank Account"
    static let suiteName = "group.com.tae.Florentin.ShoppingLand"
    
    // Function to set the balance for ShoppingLand Account
    static func setBalance(toAmount amount: Double) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        defaults.set(amount, forKey: bankAccountKey)
        defaults.synchronize()
    }
    
    // Function to check the balance of ShoppingLand Account
    static func checkBalance() -> Double? {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return nil }
        defaults.synchronize()
        let balance = defaults.double(forKey: bankAccountKey)
        return balance
    }
    
    // Function to withdraw money from ShoppingLand Account
    @discardableResult
    static func withdraw(amount: Double) -> Double? {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return nil }
        let balance = defaults.double(forKey: bankAccountKey)
        let newBalance = balance - amount
        setBalance(toAmount: newBalance)
        return newBalance
    }
    
    // Function to deposit money in the ShoppingLand Account
    @discardableResult
    static func deposit(amount: Double) -> Double? {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return nil }
        let balance = defaults.double(forKey: bankAccountKey)
        let newBalance = balance + amount
        setBalance(toAmount: newBalance)
        return newBalance
    }
}
