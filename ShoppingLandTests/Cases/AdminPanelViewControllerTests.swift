//
//  AdminPanelViewControllerTests.swift
//  ShoppingLandTests
//
//  Created by Florentin Lupascu on 09/07/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import XCTest
@testable import ShoppingLand

class AdminPanelViewControllerTests: XCTestCase {
    
    var components: AdminPanelViewController!
    
    
    override func setUp() {
        super.setUp()
        
    }

    func testProductNameTextFieldLimit() {
        
        let storyboard = UIStoryboard(name: "AdminPanel", bundle: Bundle(for: type(of: self)))
        let vc = storyboard.instantiateViewController(withIdentifier: "AdminPanelViewController") as! AdminPanelViewController
        vc.loadView()

        // Test maximum number of allowable characters
        let atTheLimitString = String(repeating: String("a") as String, count: 20)
        let atTheLimitResult = vc.textField(vc.productNameTextfield, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: atTheLimitString)
        
        XCTAssertTrue(atTheLimitResult, "The text field should allow \(20) characters")

        // Test one more than the maximum number of allowable characters
        let overTheLimitString = String(repeating: String("a") as String, count: 20+1)
        let overTheLimitResult = vc.textField(vc.productNameTextfield, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: overTheLimitString)
        XCTAssertFalse(overTheLimitResult, "The text field should not allow \(20+1) characters")
    }
    
    
    func testDescriptionNameTextFieldLimit() {
        
        let storyboard = UIStoryboard(name: "AdminPanel", bundle: Bundle(for: type(of: self)))
        let vc = storyboard.instantiateViewController(withIdentifier: "AdminPanelViewController") as! AdminPanelViewController
        vc.loadView()
        
        // Test maximum number of allowable characters
        let atTheLimitString = String(repeating: String("a") as String, count: 150)
        let atTheLimitResult = vc.textField(vc.productNameTextfield, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: atTheLimitString)
        
        XCTAssertTrue(atTheLimitResult, "The text field should allow \(150) characters")
        
        // Test one more than the maximum number of allowable characters
        let overTheLimitString = String(repeating: String("a") as String, count: 150+1)
        let overTheLimitResult = vc.textField(vc.productNameTextfield, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: overTheLimitString)
        XCTAssertFalse(overTheLimitResult, "The text field should not allow \(150+1) characters")
    }
}
