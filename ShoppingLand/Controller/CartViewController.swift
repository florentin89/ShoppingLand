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
    
    var productsInCartArray = [Product]()
    var productPricesArray = [Float]()
    
    // Life Cycle States
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCartTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCartTableView()
    }
    
    // Append the selectedProducts into productsInCartArray using the TabBarController
    func fetchSelectedProducts() {
        
        productsInCartArray = ((self.tabBarController?.viewControllers![0] as! UINavigationController).topViewController as! ProductsViewController).selectedProductsArray
    }
    
    // Function to update the Cart table view
    func updateCartTableView(){
        
        fetchSelectedProducts()
        
        // Remove last cell from TableView
        cartTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: cartTableView.frame.size.width, height: 1))
        cartTableView.reloadData()
    }
   
    // Function to redirect you on Amazon if you want to buy the specific product
    @IBAction func cartBuyProductButton(_ sender: Any) {
        
        if let selectedIndexPath = cartTableView.indexPathForSelectedRow{
            let productNameWithSpaces = productsArray[selectedIndexPath.row].name!
            var productNameWithoutSpaces = productNameWithSpaces.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            guard let amazonLink = URL(string: Constants.amazonURL + productNameWithoutSpaces) else {
                productNameWithoutSpaces = Constants.amazonDefaultSearch
                return}
            
            UIApplication.shared.open(amazonLink, options: [:], completionHandler: nil)
        }
        else{
            print(Constants.errorMessage)
        }
    }
    
    // In the future here can be a form with all user details to complete the payment.
    @IBAction func cartCheckoutButton(_ sender: Any) {
        
        showAlertWith(title: Constants.inProgress, message: Constants.messageInProgress)
    }
    
    // Show a custom Alert
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// Protocol functions for Cart TableView
extension CartViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0: // Section with Qty + ProdName + Price
            
            cartTableView.rowHeight = 100
            cartTableView.estimatedRowHeight = 100
            
            let cell = cartTableView.dequeueReusableCell(withIdentifier: Constants.identifierCartProductDetailsCell, for: indexPath) as! CartTableViewCell
            let productQuantity = 1 // hardcoded
            
            DispatchQueue.main.async {
                
            cell.cartProductQuantityLabel.text = Constants.quantityLabel + String(productQuantity)
            cell.cartProductNameLabel.text = self.productsInCartArray[indexPath.row].name
            cell.cartProductPriceLabel.text = String(self.productsInCartArray[indexPath.row].price) + Constants.currencyPound
            cell.cartProductImageView.image = UIImage(named: Constants.defaultPhotoProduct)
            }
            
            cell.buyFromAmazonBtn.layer.cornerRadius = 8
            cell.buyFromAmazonBtn.layer.borderWidth = 2
            cell.buyFromAmazonBtn.layer.borderColor = UIColor.white.cgColor
            
            return cell
            
        case 1: // Section with Total Price + Checkout Btn
            
            cartTableView.rowHeight = 70
            cartTableView.estimatedRowHeight = 70
            
            let cell = cartTableView.dequeueReusableCell(withIdentifier: Constants.identifierCartTotalPriceCell, for: indexPath) as! CartTableViewCell
            
            var totalSum: Float = 0
            
            for eachProduct in productsInCartArray{
                
               productPricesArray.append(eachProduct.price)
               totalSum = productPricesArray.reduce(0, +)
                
              cell.cartTotalPriceLabel.text = String(totalSum) + Constants.currencyPound
                
                print(productPricesArray)
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return productsInCartArray.count
        case 1: return 1
        default:
            return 0
        }
    }
}
