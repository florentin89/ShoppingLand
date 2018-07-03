//
//  EFViewController.swift
//  ShoppingLand
//
//  Created by Florentin Lupascu on 03/07/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit
import EFInternetIndicator

class EFViewController: UIViewController, InternetStatusIndicable {
    
    var internetConnectionIndicator:InternetViewIndicator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startMonitoringInternet(backgroundColor:UIColor.red, style: .statusLine, textColor:UIColor.white, message:"ShoppingLand require Internet Connection")
    }
}
