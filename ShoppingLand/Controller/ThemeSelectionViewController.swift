//
//  ThemeSelectionViewController.swift
//  ShoppingLand
//
//  Created by Florentin Lupascu on 06/07/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit

class ThemeSelectionViewController: UIViewController {

    @IBOutlet weak var lightThemeBtnOutlet: UIButton!
    @IBOutlet weak var darkThemeBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize Buttons
        lightThemeBtnOutlet.layer.cornerRadius = lightThemeBtnOutlet.frame.size.height/2
        darkThemeBtnOutlet.layer.cornerRadius = darkThemeBtnOutlet.frame.size.height/2
    }

    // Change the Profit page theme into Light
    @IBAction func lightThemeButton(_ sender: UIButton) {
        let name = Notification.Name(rawValue: lightThemeNotificationKey)
        NotificationCenter.default.post(name: name, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    // Change the Profit page theme into Dark
    @IBAction func darkThemeButton(_ sender: UIButton) {
        let name = Notification.Name(rawValue: darkThemeNotificationKey)
        NotificationCenter.default.post(name: name, object: nil)
        dismiss(animated: true, completion: nil)
    }
}
