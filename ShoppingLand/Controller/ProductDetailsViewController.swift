//
//  DetailsViewController.swift
//  ComputersLand
//
//  Created by Florentin Lupascu on 21/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit
import Social
import KRProgressHUD
import EventKit
import SCLAlertView

class ProductDetailsViewController: EFViewController {
    
    // Interface Links
    @IBOutlet var detailsTableView: UITableView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var shareBtnOutlet: UIButton!
    @IBOutlet weak var preorderBtnOutlet: UIButton!
    
    // Properties
    var selectedProduct: Product!
    var getProductImage = UIImage()
    
    // Life Cycles States
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        KRProgressHUD.show(withMessage: Constants.loadingMessage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { KRProgressHUD.dismiss() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeLayout()
    }
    
    func customizeLayout(){
        
        title = Constants.productDetailsTitle
        
        DispatchQueue.main.async {
            
            self.productImageView.image = UIImage(named: Constants.defaultPhotoProduct)
            self.productNameLabel.text = Constants.productNameLabel + self.selectedProduct.name!
            self.productCategoryLabel.text = Constants.productCategoryLabel + self.selectedProduct.category!
            self.productDescriptionLabel.text = Constants.productDescriptionLabel + self.selectedProduct.prodDescription!
            self.productPriceLabel.text = Constants.productPriceLabel + String(format: Constants.floatTwoDecimals, self.selectedProduct.price)
        }
        
        // Customize Share Btn
        shareBtnOutlet.layer.cornerRadius = 8
        shareBtnOutlet.layer.borderWidth = 2
        shareBtnOutlet.layer.borderColor = UIColor.white.cgColor
        
        // Customize PreOrder Btn
        preorderBtnOutlet.layer.cornerRadius = 8
        preorderBtnOutlet.layer.borderWidth = 2
        preorderBtnOutlet.layer.borderColor = UIColor.white.cgColor
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
    
    // Function to create an event in the callendar to remember you to buy a product
    @IBAction func createRemindToBuyEvent(_ sender: Any) {
        
        let eventStore: EKEventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if(granted) && (error == nil){
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = Constants.reminderTitleBuyProduct
                event.startDate = Date()
                event.endDate = Date()
                event.notes = Constants.reminderMessageBuyProduct
                event.calendar = eventStore.defaultCalendarForNewEvents
                do{
                    try eventStore.save(event, span: .thisEvent)
                }catch _ as NSError{
                    DispatchQueue.main.async {
                    SCLAlertView().showError(Constants.error, subTitle: Constants.errorSavingEvent)
                    }
                }
                DispatchQueue.main.async {
                SCLAlertView().showSuccess(Constants.success, subTitle: Constants.eventSavedSuccessfull)
                }
            } else{
                DispatchQueue.main.async {
                SCLAlertView().showError(Constants.error, subTitle: Constants.accessDeniedCalendar)
                }
            }
        }
    }
}
