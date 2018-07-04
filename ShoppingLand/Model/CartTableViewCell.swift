//
//  CartTableViewCell.swift
//  ComputersLand
//
//  Created by Florentin Lupascu on 22/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit

protocol ButtonInCellDelegate: class {
    
    // Function to detect when the user press the Buy button on a cell in the CartViewController
    func didTouchBuyButton(_ button: UIButton, inCell: UITableViewCell)
}

class CartTableViewCell: UITableViewCell {

    // Components of CartTableView Cell
    
    @IBOutlet weak var cartProductImageView: UIImageView!
    @IBOutlet weak var cartProductQuantityLabel: UILabel!
    @IBOutlet weak var cartProductNameLabel: UILabel!
    @IBOutlet weak var cartProductPriceLabel: UILabel!
    @IBOutlet weak var cartTotalPriceLabel: UILabel!
    @IBOutlet weak var buyFromAmazonBtn: UIButton!
    @IBOutlet weak var checkoutBtnOutlet: UIButton!
    
    weak var delegate: ButtonInCellDelegate?
    
    @IBAction func buySelectedProductBtn(_ sender: UIButton) {
        delegate?.didTouchBuyButton(sender, inCell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
