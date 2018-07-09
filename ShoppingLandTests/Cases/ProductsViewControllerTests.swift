//
//  ProductsViewControllerTests.swift
//  ShoppingLandTests
//
//  Created by Florentin Lupascu on 09/07/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import XCTest
@testable import ShoppingLand

class ProductsViewControllerTests: XCTestCase {


    // Test if fetchPhotosForProductsFromGoogle is returning an OK status.
    func testFetchPhotosForProductsFromGoogleGetsHTTPStatusCode200(){

        let url = URL(string: "https://www.googleapis.com/customsearch/v1?q=iPhone_X&imgType=photo&imgSize=medium&searchType=image&cx=004797504301667307438:v974oybby28&key=AIzaSyA_QlOnYMZLbFCV_oh49Z97_tx7zA-Qeig")

        let promise = expectation(description: "Status code: 200")

        let dataTask = URLSession.shared.dataTask(with: url!) { data, response, error in

            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {

                    promise.fulfill()
                } else {
                    // If there are more then 100 API requests then will return Status Code 403
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()

        waitForExpectations(timeout: 5, handler: nil)

    }
    
    // Test if the badge will be updated with the number of items in the cart
    func testUpdateNoOfProductsOnIcons(){
        
        let counterItem = 3
        
        UIApplication.shared.applicationIconBadgeNumber = counterItem
        
        XCTAssertEqual(counterItem, 3)
        
        XCTAssertEqual(UIApplication.shared.applicationIconBadgeNumber, counterItem)
    }

}
