//
//  ProfitViewController.swift
//  ShoppingLand
//
//  Created by Florentin Lupascu on 04/07/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit
import Intents

let lightThemeNotificationKey = Constants.lightThemeNotificationKey
let darkThemeNotificationKey = Constants.darkThemeNotificationKey

class ProfitViewController: UIViewController {

    // Interface Links
    @IBOutlet weak var titlePageLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var checkBalanceBtnOutlet: UIButton!
    @IBOutlet weak var changeThemeBtnOutlet: UIButton!
    
    let lightTheme = Notification.Name(rawValue: lightThemeNotificationKey)
    let darkTheme = Notification.Name(rawValue: darkThemeNotificationKey)
    
    // Remove observer from memory after we use it
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize Reset Btn
        checkBalanceBtnOutlet.layer.cornerRadius = 8
        checkBalanceBtnOutlet.layer.borderWidth = 2
        checkBalanceBtnOutlet.layer.borderColor = UIColor.white.cgColor
        
        // Customize ChangeTheme Btn
        changeThemeBtnOutlet.layer.cornerRadius = changeThemeBtnOutlet.frame.size.height/2
        
        INPreferences.requestSiriAuthorization { (status) in }
        if BankAccount.checkBalance()!.isZero {
            BankAccount.setBalance(toAmount: 100)
        }
        createObservers()
    }
    
    // Function to create the observers
    func createObservers(){
        
        // Light Theme
        NotificationCenter.default.addObserver(self, selector: #selector(ProfitViewController.updateTitleColor(notification:)), name: lightTheme, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfitViewController.updateBalanceLabelColor(notification:)), name: lightTheme, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfitViewController.updateCheckBalanceBtnColor(notification:)), name: lightTheme, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfitViewController.updateBackground(notification:)), name: lightTheme, object: nil)
        
        // Dark Theme
        NotificationCenter.default.addObserver(self, selector: #selector(ProfitViewController.updateTitleColor(notification:)), name: darkTheme, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfitViewController.updateBalanceLabelColor(notification:)), name: darkTheme, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfitViewController.updateCheckBalanceBtnColor(notification:)), name: darkTheme, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfitViewController.updateBackground(notification:)), name: darkTheme, object: nil)
    }
    
    @objc func updateTitleColor(notification: NSNotification){
        let isLightTheme = notification.name == lightTheme
        isLightTheme ? (titlePageLabel.textColor = .black) : (titlePageLabel.textColor = .white)
    }
    
    @objc func updateBalanceLabelColor(notification: NSNotification){
        let isLightTheme = notification.name == lightTheme
        isLightTheme ? (balanceLabel.textColor = .red) : (balanceLabel.textColor = .green)
    }
    
    @objc func updateCheckBalanceBtnColor(notification: NSNotification){
        let isLightTheme = notification.name == lightTheme
        isLightTheme ? (checkBalanceBtnOutlet.backgroundColor = .black) : (checkBalanceBtnOutlet.backgroundColor = .blue)
        isLightTheme ? (checkBalanceBtnOutlet.setTitleColor(.green, for: .normal)) : (checkBalanceBtnOutlet.setTitleColor(.white, for: .normal))
    }
    
    @objc func updateBackground(notification: NSNotification){
        let isLightTheme = notification.name == lightTheme
        let color = isLightTheme ? UIColor.white : UIColor.black
        view.backgroundColor = color
    }
    
    // Btn to check the balance of the bank account
    @IBAction func checkBalance(){
        guard let balance = BankAccount.checkBalance() else { return }
        balanceLabel.text = Constants.accountBalance + String(balance)
    }
    
    @IBAction func changeThemeBtn(_ sender: UIButton) {
        let selectionVC = storyboard?.instantiateViewController(withIdentifier: Constants.identifierThemeSelection) as! ThemeSelectionViewController
        present(selectionVC, animated: true, completion: nil)
    }
}
