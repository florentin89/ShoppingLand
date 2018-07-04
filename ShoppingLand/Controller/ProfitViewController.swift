//
//  ProfitViewController.swift
//  ShoppingLand
//
//  Created by Florentin Lupascu on 04/07/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit
import Intents

class ProfitViewController: UIViewController {

    // Interface Links
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var checkBalanceBtnOutlet: UIButton!
    
    // Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize Reset Btn
        checkBalanceBtnOutlet.layer.cornerRadius = 8
        checkBalanceBtnOutlet.layer.borderWidth = 2
        checkBalanceBtnOutlet.layer.borderColor = UIColor.white.cgColor
        
        INPreferences.requestSiriAuthorization { (status) in }
        if BankAccount.checkBalance()!.isZero {
            BankAccount.setBalance(toAmount: 100)
        }
    }
    
    // Btn to check the balance of the bank account
    @IBAction func checkBalance(){
        
        guard let balance = BankAccount.checkBalance() else { return }
        balanceLabel.text = "Account Balance: £\(balance)"
    }
}
