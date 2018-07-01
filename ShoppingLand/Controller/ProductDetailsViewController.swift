//
//  DetailsViewController.swift
//  ComputersLand
//
//  Created by Florentin Lupascu on 21/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit
import Social

class ProductDetailsViewController: UITableViewController {
    
    // Interface Links
    @IBOutlet var detailsTableView: UITableView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    // Properties
    var selectedProduct: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.productDetailsTitle
        
        DispatchQueue.main.async {
            
            self.productImageView.image = UIImage(named: Constants.defaultPhotoProduct)
            self.productNameLabel.text = Constants.productNameLabel + self.selectedProduct.name!
            self.productCategoryLabel.text = Constants.productCategoryLabel + self.selectedProduct.category!
            self.productDescriptionLabel.text = Constants.productDescriptionLabel + self.selectedProduct.prodDescription!
            self.productPriceLabel.text = Constants.productPriceLabel + String(format: Constants.floatTwoDecimals, self.selectedProduct.price)
        }
    }
    
    // Share the ProductName, ProductImage and Website on Socials
    @IBAction func shareProductButton(_ sender: UIButton) {
        
        guard let text = productNameLabel.text else {
            productNameLabel.text = ""
            return
        }
        
        guard let image = productImageView.image else {
            productImageView.image = UIImage()
            return
        }
        
        guard let myWebsite = NSURL(string: Constants.websiteAppExperts) else { return }
        
        let shareAll = [text, image, myWebsite] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}
