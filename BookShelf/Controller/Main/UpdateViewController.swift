//
//  UpdateViewController.swift
//  BookShelf
//
//  Created by Abu FaisaL on 10/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import iOSDropDown
class UpdateViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var sectionTextField: DropDown!
    @IBOutlet weak var bookStausLabel: UILabel!
    @IBOutlet weak var bookStatusTextField: DropDown!
    @IBOutlet weak var pricesLabel: UILabel!
    @IBOutlet weak var pricesTF: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var updateImageBook: UIImageView!
    var image: UIImage? = nil
    let db = Firestore.firestore()
    var user:User!
   
    var book:Book!
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        shadow()
        sectionTextField.optionArray = ["Islmic Book","Childern Book","Cook Book","Educational Book","Other Book"]
        bookStatusTextField.optionArray = ["New","Used"]

      
    }
        func cornerRadius(){
           
            nameLabelTextField.layer.cornerRadius = 10
            nameLabelTextField.layer.borderWidth = 1
            nameLabelTextField.layer.borderColor = UIColor.red.cgColor
           
            descriptionTextView.layer.cornerRadius = 10
            descriptionTextView.layer.borderWidth = 1
            descriptionTextView.layer.borderColor = UIColor.red.cgColor
           
            sectionTextField.layer.cornerRadius = 10
            sectionTextField.layer.borderWidth = 1
            sectionTextField.layer.borderColor = UIColor.red.cgColor
           
            bookStatusTextField.layer.cornerRadius = 10
            bookStatusTextField.layer.borderWidth = 1
            bookStatusTextField.layer.borderColor = UIColor.red.cgColor
            updateBtn.layer.cornerRadius = 10
            updateBtn.layer.borderWidth = 1
            updateBtn.layer.borderColor = UIColor.red.cgColor
      }
    func shadow(){
        updateBtn.layer.shadowColor = UIColor.black.cgColor
        updateBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        updateBtn.layer.shadowRadius = 8
        updateBtn.layer.shadowOpacity = 0.5
        updateBtn.layer.masksToBounds = false
    }
    @IBAction func addImage(_ sender: UIButton) {
      setupImage()
      }
            
    func setupImage() {
        updateImageBook.contentMode = .scaleAspectFit
        updateImageBook.layer.borderWidth = 1
        updateImageBook.layer.masksToBounds = false
        updateImageBook.layer.borderColor = UIColor.black.cgColor
        updateImageBook.layer.cornerRadius = updateImageBook.frame.height/2
        updateImageBook.clipsToBounds = true
        updateImageBook.isUserInteractionEnabled = true
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(presntPicker))
        updateImageBook.addGestureRecognizer(tabGesture)
    }

    @objc func presntPicker() {
      let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func updatePressed(_ sender: UIButton) {
        let washingtonRef = db.collection("Users").document(Auth.auth().currentUser!.uid)

        washingtonRef.updateData([
            "name":nameLabelTextField.text,
            "description":descriptionTextView.text ,
            "section":sectionTextField.text ,
            "bookStatus":bookStatusTextField.text,
            "price":pricesTF.text,
            "BookID": db.collection("Users").document().documentID
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }

    }

  }
extension UpdateViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            image = imageSelected
            updateImageBook.image = imageSelected
      }
        if let imageOriginal = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            image = imageOriginal
           updateImageBook.image = imageOriginal
      }

        picker.dismiss(animated: true, completion: nil)
  }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
