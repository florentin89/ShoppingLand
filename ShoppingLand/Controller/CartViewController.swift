//
//  CartViewController.swift
//  ComputersLand
//
//  Created by Florentin Lupascu on 21/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit
import KRProgressHUD
import SCLAlertView
import Kingfisher

class CartViewController: UIViewController, ButtonInCellDelegate {
    
    // Interface Links
    @IBOutlet weak var cartTableView: UITableView!
    
    // Properties
    var productsInCartArray = [Product]()
    var productPricesArray = [Float]()
    var getProductsPhotosArray = [Item]()
    var totalSum: Float?
    
    // Life Cycle States
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        KRProgressHUD.show(withMessage: Constants.loadingMessage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCartTableView()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { KRProgressHUD.dismiss() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateCartTableView()
    }
    
    // Append the selectedProducts into productsInCartArray using the TabBarController
    func fetchSelectedProducts() {
        let firstTabVC = ((self.tabBarController?.viewControllers![0] as! UINavigationController).viewControllers[0] as! ProductsViewController)
        productsInCartArray = firstTabVC.selectedProductsArray
        productPricesArray = firstTabVC.priceForSelectedProductsArray
        getProductsPhotosArray = firstTabVC.googlePhotosArray
        totalSum = productPricesArray.reduce(0, +)
    }
    
    // Function to update the Cart table view
    func updateCartTableView(){
        
        fetchSelectedProducts()
        cartTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: cartTableView.frame.size.width, height: 1)) // Remove last cell from TableView
        cartTableView.reloadData()
    }
    
    // Function to redirect you on Amazon if you want to buy the specific product
    func didTouchBuyButton(_ button: UIButton, inCell: UITableViewCell) {
        
        if let indexPath = cartTableView.indexPath(for: inCell){
            let productNameWithSpaces = productsInCartArray[indexPath.row].name!
            var productNameWithoutSpaces = productNameWithSpaces.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            guard let amazonLink = URL(string: Constants.amazonURL + productNameWithoutSpaces) else {
                productNameWithoutSpaces = Constants.amazonDefaultSearch
                return
            }
            UIApplication.shared.open(amazonLink, options: [:], completionHandler: nil)
        }
        else{
            SCLAlertView().showError(Constants.error, subTitle: Constants.urlNotFound)
        }
    }
    
    // In the future here can be a form with all user details to complete the payment.
    @IBAction func cartCheckoutButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: Constants.payPalURL)!, options: [:], completionHandler: nil)
    }
    
    // Clear all products from the cart
    @IBAction func clearAllProducts(_ sender: Any) {
        
        // Reset Cart tableView
        productsInCartArray = [Product]()
        productPricesArray = [Float]()
        totalSum = 0
        self.tabBarController?.tabBar.items?[1].badgeValue = String(0)
        
        // Remove selected products from ProductsViewController
        let firstTabTVC = ((self.tabBarController?.viewControllers![0] as! UINavigationController).topViewController as! ProductsViewController)
        firstTabTVC.selectedProductsArray = [Product]()
        firstTabTVC.priceForSelectedProductsArray = [Float]()
        firstTabTVC.counterItem = 0
        firstTabTVC.numberOfProductsInCartLabel.text = String(0)
        UIApplication.shared.applicationIconBadgeNumber = 0
        cartTableView.reloadData()
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
                
                let productPhotoURL = self.getProductsPhotosArray.first?.link ?? Constants.defaultProductPhotoURL
                let resourcePhoto = ImageResource(downloadURL: URL(string: productPhotoURL)!, cacheKey: productPhotoURL)
                
                cell.cartProductImageView.kf.setImage(with: resourcePhoto)
                cell.cartProductQuantityLabel.text = Constants.quantityLabel + String(productQuantity)
                cell.cartProductNameLabel.text = self.productsInCartArray[indexPath.row].name
                cell.cartProductPriceLabel.text = String(format: Constants.floatTwoDecimals, self.productsInCartArray[indexPath.row].price) + Constants.currencyPound
            }
            
            // Customize Amazon Button
            cell.buyFromAmazonBtn.layer.cornerRadius = 8
            cell.buyFromAmazonBtn.layer.borderWidth = 2
            cell.buyFromAmazonBtn.layer.borderColor = UIColor.white.cgColor
            cell.delegate = self
            
            return cell
            
        case 1: // Section with Total Price + Checkout Btn
            
            cartTableView.rowHeight = 70
            cartTableView.estimatedRowHeight = 70
            
            let cell = cartTableView.dequeueReusableCell(withIdentifier: Constants.identifierCartTotalPriceCell, for: indexPath) as! CartTableViewCell
            
            if let finalPrice = totalSum, finalPrice > 0 {
                cell.cartTotalPriceLabel.text = String(format: Constants.floatTwoDecimals, finalPrice) + Constants.currencyPound
            }
            else{
                cell.cartTotalPriceLabel.text = String(0.00) + Constants.currencyPound
            }
            
            // Customize Checkout Button
            cell.checkoutBtnOutlet.layer.cornerRadius = 8
            cell.checkoutBtnOutlet.layer.borderWidth = 2
            cell.checkoutBtnOutlet.layer.borderColor = UIColor.white.cgColor
            
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
    
    // Function to delete a product from the cart
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let firstTabVC = ((self.tabBarController?.viewControllers![0] as! UINavigationController).viewControllers[0] as! ProductsViewController)
            firstTabVC.selectedProductsArray.remove(at: indexPath.row)
            firstTabVC.priceForSelectedProductsArray.remove(at: indexPath.row)
            
            productsInCartArray.remove(at: indexPath.row)
            productPricesArray.remove(at: indexPath.row)
            cartTableView.deleteRows(at: [indexPath], with: .fade)
            totalSum = productPricesArray.reduce(0, +)
            self.tabBarController?.tabBar.items?[1].badgeValue = String(productsInCartArray.count)
            
            cartTableView.reloadData()
        }
    }
}
