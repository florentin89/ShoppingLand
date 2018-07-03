//
//  ProductTableViewCell.swift
//  ComputersLand
//
//  Created by Florentin Lupascu on 21/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    
    // Function to detect when the user press the Add To Cart button.
    func didTapAddToCart(_ cell: ProductTableViewCell)
}

class ProductTableViewCell: UITableViewCell {

    // Components of ProductTableView Cell
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    
    weak var delegate: CellDelegate?
   
    @IBAction func addToCartPressed(_ sender: Any) {
        delegate?.didTapAddToCart(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
