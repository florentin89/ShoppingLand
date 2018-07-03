//
//  AdminPanelViewController.swift
//  ComputersLand
//
//  Created by Florentin Lupascu on 22/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit
import CoreData
import KRProgressHUD
import SCLAlertView

var productsArray = [Product]()

class AdminPanelViewController: EFViewController {
    
    // Interface Links
    @IBOutlet var adminTableView: UITableView!
    @IBOutlet weak var adminUsernameLabel: UILabel!
    @IBOutlet weak var productNameTextfield: UITextField!
    @IBOutlet weak var productCategoryTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var productPriceTextfield: UITextField!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var resetBtnOutlet: UIButton!
    
    // Properties
    var currentUser = UIDevice.current.name
    
    // Life Cycle States
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        KRProgressHUD.show(withMessage: Constants.loadingMessage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetAllFields()
        userPhotoImageView.contentMode = .scaleToFill
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { KRProgressHUD.dismiss() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateInterface()
    }
    
    // Function to update the properties of AdminVC
    func updateInterface(){
        loadUserPhoto()
        initializeFields()
        customizeLayout()
        dismissKeyboard()
    }
    
    // Function to initalize the textfields
    func initializeFields(){
        
        title = Constants.adminPanelTitle
        userPhotoImageView.backgroundColor = .lightGray
        adminUsernameLabel.text = Constants.currentUser + currentUser
        productNameTextfield.delegate = self
        productCategoryTextField.delegate = self
        productDescriptionTextView.delegate = self
        productPriceTextfield.delegate = self
        productPriceTextfield.keyboardType = .decimalPad
    }
    
    // Func to customize the layout interface
    func customizeLayout(){
        
        // Customize Save Btn
        saveBtnOutlet.layer.cornerRadius = 10
        saveBtnOutlet.layer.borderWidth = 2
        saveBtnOutlet.layer.borderColor = UIColor.white.cgColor
        
        // Customize Reset Btn
        resetBtnOutlet.layer.cornerRadius = 10
        resetBtnOutlet.layer.borderWidth = 2
        resetBtnOutlet.layer.borderColor = UIColor.white.cgColor
        
        // Customize Description TextView
        productDescriptionTextView.layer.cornerRadius = 5.0
        productDescriptionTextView.layer.borderWidth = 1
        productDescriptionTextView.layer.borderColor = UIColor.black.cgColor
        
        // Remove last cell from TableView
        adminTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: adminTableView.frame.size.width, height: 1))
    }
    
    // Close the keyboard when you press outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Close the keyboard when you press outside of textfields
    func dismissKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    // Save the new product in the CoreData
    @IBAction func saveProductButton(_ sender: UIButton) {
        insertProduct()
    }
    
    // Func to insert data from TextFields into CoreData
    func insertProduct(){
        
        guard let productName = productNameTextfield.text, productName != "" else{
            SCLAlertView().showError(Constants.nameRequired, subTitle: Constants.messageNameRequired)
            return
        }
        guard let productCategory = productCategoryTextField.text, productCategory != "" else{
            SCLAlertView().showError(Constants.categoryRequired, subTitle: Constants.messageCategoryRequired)
            return
        }
        guard let productDescription = productDescriptionTextView.text, productDescription != ""else{
            SCLAlertView().showError(Constants.descriptionRequired, subTitle: Constants.messageDescriptionRequired)
            return
        }
        guard let productPrice = productPriceTextfield.text, productPrice != "" else{
            SCLAlertView().showError(Constants.priceRequired, subTitle: Constants.messagePriceRequired)
            return
        }
        
        let product = Product(context: context) // Start inserting in Core Data
        let productUUID = UUID().uuidString
        product.id = productUUID
        product.name = productName
        product.category = productCategory
        product.prodDescription = productDescription
        product.price = Float(productPrice)!
        
        appDelegate.saveContext() // End inserting and save the content in Core Data
        resetAllFields()
        SCLAlertView().showSuccess(Constants.done, subTitle: Constants.messageProductAdded)
    }
    
    // Reset All Fields
    @IBAction func resetFieldsButton(_ sender: UIButton) {
        
        resetAllFields()
    }
    
    // Reset All Fields
    func resetAllFields(){
        
        productNameTextfield.text = ""
        productCategoryTextField.text = ""
        productDescriptionTextView.text = ""
        productPriceTextfield.text = ""
    }
    
    // Button to change User Photo
    @IBAction func changeUserPhoto(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Button to save User Photo
    @IBAction func saveUserPhoto(_ sender: UIButton) {
        
        // Encode the user photo
        let image = userPhotoImageView.image
        let imageData:NSData = UIImagePNGRepresentation(image!)! as NSData
        
        // Save the selected user photo
        UserDefaults.standard.set(imageData, forKey: Constants.nameOfSavedUserPhoto)
        loadUserPhoto()
        SCLAlertView().showSuccess(Constants.done, subTitle: Constants.messagePhotoSaved)
    }
    
    // Function used to load the selected User Photo
    func loadUserPhoto(){
        
        // Decode the selected user photo
        guard let data = UserDefaults.standard.object(forKey: Constants.nameOfSavedUserPhoto) as? NSData else{
            userPhotoImageView.image = UIImage(named: Constants.defaultPhotoUser)
            return
        }
        userPhotoImageView.image = UIImage(data: data as Data)
        userPhotoImageView.contentMode = .scaleToFill
    }
}

extension AdminPanelViewController: UITextFieldDelegate, UITextViewDelegate{
    
    // Function to verify the TextFields input
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // Don't allow user to enter spaces in textfields at beginning
        if textField == productNameTextfield || textField == productCategoryTextField {

            if Int(range.location) == 0 && (string == " ") {
                return false
            }
            else{
                return true
            }
        }
        //allow the user to enter only digits and punctuation for Price textfield
        if (textField == productPriceTextfield) {
            let allowedCharacters = Constants.allowedCharacters
            return allowedCharacters.contains(string) || range.length == 1
        }
        return true
    }
    
    // Function to verify the TextViews input
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == productDescriptionTextView{
            if Int(range.location) == 0 && (text == " ") {
                return false
            }
            else{
                return true
            }
        }
        return true
    }
}

// Extension for UserPhoto ImageView to dismiss the Controller when you press Cancel or to load the selected image from library
extension AdminPanelViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            userPhotoImageView.contentMode = .scaleAspectFit
            userPhotoImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
