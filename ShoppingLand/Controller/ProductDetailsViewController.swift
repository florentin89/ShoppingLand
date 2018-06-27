//
//  DetailsViewController.swift
//  ComputersLand
//
//  Created by Florentin Lupascu on 21/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UITableViewController {
    
    @IBOutlet var detailsTableView: UITableView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    var selectedProduct: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Product Details"
        
        DispatchQueue.main.async {
         
            self.productImageView.image = UIImage(named: "ImageProduct.jpg")
            self.productNameLabel.text = "Name: \(self.selectedProduct.name!)"
            self.productCategoryLabel.text = "Category: \(self.selectedProduct.category!)"
            self.productDescriptionLabel.text = "Description: \(self.selectedProduct.prodDescription!)"
            self.productPriceLabel.text = "Price: \(String(format: "%.2f", self.selectedProduct.price))"
            
        }
    }
    
    @IBAction func shareProductButton(_ sender: UIButton) {
    
        // Share on FB / Twitter
        
    }
}
