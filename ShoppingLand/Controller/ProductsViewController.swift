//
//  ViewController.swift
//  ComputersLand
//
//  Created by Florentin Lupascu on 21/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, PhotoSentDelegate {
    
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var numberOfProductsInCartLabel: UILabel!
    @IBOutlet weak var shoppingCartButton: UIButton!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var helloUserLabel: UILabel!
    
    var counterItem = 0
    var productCell = ProductTableViewCell()
    var cartVC = CartViewController()
    var adminVC = AdminPanelViewController()
    
    // Life Cycle States
    override func viewDidLoad() {
        super.viewDidLoad()

        accessToAdminPanel()
        updateProducts()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        userAvatarImageView.contentMode = .scaleToFill
        updateProducts()
        
    }
    
    // Get UserPhoto from AdminViewController using the Delegation Pattern
    func getUserPhoto(image: UIImage) {
        userAvatarImageView.image = image
        print(image)
    }
    
    // Function to send details about a product from this VC to ProductDetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let selectedIndexPath = productsTableView.indexPathForSelectedRow{
            let destinationVC = segue.destination as! ProductDetailsViewController
            destinationVC.selectedProduct = productsArray[selectedIndexPath.row]
        }
        
        if segue.identifier == "AdminPanelStoryboard" {
            let adminVC: AdminPanelViewController = segue.destination as! AdminPanelViewController
            adminVC.delegate = self
        }
    }
    
    // Function to update the Products Table View
    func updateProducts(){
       
        numberOfProductsInCartLabel.layer.cornerRadius = numberOfProductsInCartLabel.frame.size.height / 2
        
        do{
            productsArray = try context.fetch(Product.fetchRequest())
            
            // Remove last cell from TableView
            productsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: productsTableView.frame.size.width, height: 1))
            
            productsTableView.rowHeight = 150
            productsTableView.estimatedRowHeight = 150
            
            productsTableView.reloadData()
        }
        catch{
            print("Error fetch")
        }
    }
    
    // Navigate to Cart when you click the basket icon
    @IBAction func shoppingCartButton(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    // Func which is using GestureRecognition to access the Admin Panel when we press on User Avatar
    func accessToAdminPanel(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductsViewController.adminImageTapped(gesture:)))
        
        userAvatarImageView.addGestureRecognizer(tapGesture)
    }
    
    // Function to open the AdminPanelViewController
    @objc func adminImageTapped(gesture: UIGestureRecognizer) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let adminPanelVC = storyBoard.instantiateViewController(withIdentifier: "AdminPanelStoryboard") as! AdminPanelViewController
        self.navigationController?.pushViewController(adminPanelVC, animated: true)
        
    }
    
    // Function to animate the product into the Cart
    func animationProduct(tempView : UIView)  {
        self.view.addSubview(tempView)
        UIView.animate(withDuration: 1.0,
                       animations: {
                        tempView.animationZoom(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.5, animations: {
                
                tempView.animationZoom(scaleX: 0.2, y: 0.2)
                tempView.animationRoted(angle: CGFloat(Double.pi))
                
                tempView.frame.origin.x = self.shoppingCartButton.frame.origin.x
                tempView.frame.origin.y = self.shoppingCartButton.frame.origin.y
                
            }, completion: { _ in
                
                tempView.removeFromSuperview()
                
                UIView.animate(withDuration: 1.0, animations: {
                    
                    self.counterItem += 1
                    self.numberOfProductsInCartLabel.text = "\(self.counterItem)"
                    self.shoppingCartButton.animationZoom(scaleX: 1.4, y: 1.4)
                }, completion: {_ in
                    self.shoppingCartButton.animationZoom(scaleX: 1.0, y: 1.0)
                })
            })
        })
    }
    
    // Show a custom Alert
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Function to add the product into the cart
    @IBAction func addProductToCartButton(_ sender: UIButton) {
        
        let buttonPosition : CGPoint = sender.convert(sender.bounds.origin, to: self.productsTableView)
        let indexPath = self.productsTableView.indexPathForRow(at: buttonPosition)!
        let cell = productsTableView.cellForRow(at: indexPath) as! ProductTableViewCell
        let imageViewPosition : CGPoint = cell.productImageView.convert(cell.productImageView.bounds.origin, to: self.view)
        let imgViewTemp = UIImageView(frame: CGRect(x: imageViewPosition.x, y: imageViewPosition.y, width: cell.productImageView.frame.size.width, height: cell.productImageView.frame.size.height))
        imgViewTemp.image = cell.productImageView.image
        
        animationProduct(tempView: imgViewTemp)
        
        showAlertWith(title: "Added", message: "Product added with success.")
        
    }
    
    
}

// ProductsTableView Protocols
extension ProductsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return productsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        
        // TODO: Get the image for each product from Google using Google APIs (Custom Search Engine Key + API Key)
        
       // let productImageURL = "https://www.googleapis.com/customsearch/v1?q=\(productsArray[indexPath.row].name ?? "flagUK")&imgType=photo&imgSize=medium&searchType=image&key=AIzaSyA_QlOnYMZLbFCV_oh49Z97_tx7zA-Qeig&cx=004797504301667307438:v974oybby28"

        DispatchQueue.main.async {
          
            // Load all the images Async for a good optimization

        }
        
        cell.productTitleLabel.text = "\(productsArray[indexPath.row].name!)"
        cell.productDescriptionLabel.text = "\(productsArray[indexPath.row].prodDescription!)"
        cell.productPriceLabel.text = "\(String(format: "%.2f", productsArray[indexPath.row].price)) £" 
        cell.productImageView.image = UIImage(named: "ImageProduct.jpg")
        
        cell.addToCartBtn.layer.cornerRadius = 8
        cell.addToCartBtn.layer.borderWidth = 2
        cell.addToCartBtn.layer.borderColor = UIColor.white.cgColor
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToDetails", sender: indexPath)
    }
    
 
}


// Extension for zoom animation when the user add a product in the Cart
extension UIView{
    func animationZoom(scaleX: CGFloat, y: CGFloat) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: y)
    }
    
    func animationRoted(angle : CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }
}
