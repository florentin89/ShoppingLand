//
//  CartTableViewCell.swift
//  ComputersLand
//
//  Created by Florentin Lupascu on 22/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    // Components of CartTableView Cell
    
    @IBOutlet weak var cartProductImageView: UIImageView!
    @IBOutlet weak var cartProductQuantityLabel: UILabel!
    @IBOutlet weak var cartProductNameLabel: UILabel!
    @IBOutlet weak var cartProductPriceLabel: UILabel!
    @IBOutlet weak var cartTotalPriceLabel: UILabel!
    @IBOutlet weak var buyFromAmazonBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
