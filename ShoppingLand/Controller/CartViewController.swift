//
//  CartViewController.swift
//  ComputersLand
//
//  Created by Florentin Lupascu on 21/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit


class CartViewController: UIViewController {

    @IBOutlet weak var cartTableView: UITableView!
 
    var cartProductsArray = [Product]()
    
    // Life Cycle States
    override func viewDidLoad() {
        super.viewDidLoad()

        updateCartTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCartTableView()
    }
    
    func updateCartTableView(){
        
        // Remove last cell from TableView
        cartTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: cartTableView.frame.size.width, height: 1))
        
    }
    
    @IBAction func cartBuyProductButton(_ sender: Any) {
        // Buy the selected product from Amazon website
    }
    
    @IBAction func cartCheckoutButton(_ sender: Any) {
        
        // Idea for a future implementation: Pop-Up Allert with "PayPal payment is not implemented yet..."
        
    }
    
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0: // Section with Qty + ProdName + Price
    
            cartTableView.rowHeight = 100
            cartTableView.estimatedRowHeight = 100
            
            let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartProductDetailsCell", for: indexPath) as! CartTableViewCell
            
            let productQuantity = 1
            let productName = "nVidia GTX 1080 Overclock Edition"
            let productPrice: Double = 1999.99
            
            cell.cartProductQuantityLabel.text = "Quantity: \(productQuantity)"
            cell.cartProductNameLabel.text = "Name: \(productName)"
            cell.cartProductPriceLabel.text = "Price: \(productPrice) £"
            
            return cell
            
        case 1: // Section with Total Price + Checkout Btn
            
            cartTableView.rowHeight = 70
            cartTableView.estimatedRowHeight = 70
            
            let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartTotalPriceCell", for: indexPath) as! CartTableViewCell
            
            let totalPrice: Double = 19990.99
            
            cell.cartTotalPriceLabel.text = "\(totalPrice) £"
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 10
        case 1: return 1
        default:
            return 0
        }
        
    }
    
}
