//
//  AdminPanelViewController.swift
//  ComputersLand
//
//  Created by Florentin Lupascu on 22/06/2018.
//  Copyright © 2018 Florentin Lupascu. All rights reserved.
//

import UIKit
import CoreData

var productsArray = [Product]()

// Protocol to send the userPhoto from this VC to another VC
protocol PhotoSentDelegate{
    func getUserPhoto(image: UIImage)
}

class AdminPanelViewController: UITableViewController {
    
    @IBOutlet var adminTableView: UITableView!
    
    @IBOutlet weak var adminUsernameLabel: UILabel!
    
    @IBOutlet weak var productNameTextfield: UITextField!
    
    @IBOutlet weak var productCategoryTextField: UITextField!
    
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    @IBOutlet weak var productPriceTextfield: UITextField!
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var saveBtnOutlet: UIButton!
    
    @IBOutlet weak var resetBtnOutlet: UIButton!
    
    var currentUser = UIDevice.current.name
    var delegate: PhotoSentDelegate? = nil
    
    // Life Cycle States
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateInterface()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetAllFields()
        userPhotoImageView.contentMode = .scaleToFill
    }
    
    // Prepare the userPhoto to be send from this VC to another VC
    func sendUserPhoto(){
        if delegate != nil{
            if userPhotoImageView.image != nil {
                let userImage = userPhotoImageView.image
                delegate?.getUserPhoto(image: userImage!)
            }
        }
        else{
            print("Delegate is NIL")
        }
    }
    
    // Function to update the properties of AdminVC
    func updateInterface(){
        
        loadUserPhoto()
        sendUserPhoto()
        
        title = "Admin Panel"
        productPriceTextfield.delegate = self
        userPhotoImageView.backgroundColor = .lightGray
        adminUsernameLabel.text = "Current user: \(currentUser)"
        
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
        
        dismissKeyboard()
        
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
            showAlertWith(title: "Name required", message: "Product name is required !")
            return
        }
        guard let productCategory = productCategoryTextField.text, productCategory != "" else{
            showAlertWith(title: "Category required", message: "Product Category required !")
            return
        }
        guard let productDescription = productDescriptionTextView.text, productDescription != ""
            else{ showAlertWith(title: "Description required", message: "Product Description required !")
                return
        }
        guard let productPrice = productPriceTextfield.text, productPrice != "" else{
            showAlertWith(title: "Price required", message: "Product Price required !")
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
        showAlertWith(title: "Done", message: "Product was added with success !")
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
        let imageData:NSData = image!.pngData()! as NSData
        
        // Save the selected user photo
        UserDefaults.standard.set(imageData, forKey: "saveUserImage")
        loadUserPhoto()
        showAlertWith(title: "Done", message: "Photo was saved.", style: .alert)
    }
    
    // Function used to load the selected User Photo
    func loadUserPhoto(){
        
        // Decode the selected user photo
        guard let data = UserDefaults.standard.object(forKey: "saveUserImage") as? NSData else{
            userPhotoImageView.image = UIImage(named: "ImageUser.png")
            return
        }
        userPhotoImageView.image = UIImage(data: data as Data)
        userPhotoImageView.contentMode = .scaleToFill
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
    
}

extension AdminPanelViewController: UITextFieldDelegate{
    
    // Function which allow the user to enter only digits for Price textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

// Extension for UserPhoto ImageView to dismiss the Controller when you press Cancel or to load the selected image from library
extension AdminPanelViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            userPhotoImageView.contentMode = .scaleAspectFit
            userPhotoImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

