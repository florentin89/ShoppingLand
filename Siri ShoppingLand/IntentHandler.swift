//
//  IntentHandler.swift
//  Siri ShoppingLand
//
//  Created by Florentin Lupascu on 04/07/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import Intents

class IntentHandler: INExtension {}

// This extensions are used to speak with Siri technology
extension IntentHandler: INSendPaymentIntentHandling{
    
    // This function will send money from your ShoppingLand account using Siri technology
    func handle(intent: INSendPaymentIntent, completion: @escaping (INSendPaymentIntentResponse) -> Void) {
        
        guard let amount = intent.currencyAmount?.amount?.doubleValue else {
            completion(INSendPaymentIntentResponse(code: .failure, userActivity: nil))
            return
        }
        BankAccount.withdraw(amount: amount)
        completion(INSendPaymentIntentResponse(code: .success, userActivity: nil))
    }
}

extension IntentHandler: INRequestPaymentIntentHandling{
    
    // This function will request money to your ShoppingLand account using Siri technology
    func handle(intent: INRequestPaymentIntent, completion: @escaping (INRequestPaymentIntentResponse) -> Void) {
        
        guard let amount = intent.currencyAmount?.amount?.doubleValue else {
            completion(INRequestPaymentIntentResponse(code: .failure, userActivity: nil))
            return
        }
        BankAccount.deposit(amount: amount)
        completion(INRequestPaymentIntentResponse(code: .success, userActivity: nil))
    }
}
