//
//  AddBookViewController.swift
//  BookShelf
//
//  Created by Abu FaisaL on 09/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestore
import iOSDropDown
class AddBookViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var sectionTF: DropDown!
    @IBOutlet weak var bookStausLabel: UILabel!
    @IBOutlet weak var bookStatusTF: DropDown!
    @IBOutlet weak var pricesLabel: UILabel!
    @IBOutlet weak var pricesTextField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var addImageBook: UIImageView!
    var image: UIImage? = nil
    let db = Firestore.firestore()
    var user:User!
    var imagePicker: ImagePicker!
    var book:Book!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        shadow()
        sectionTF.optionArray = ["Islmic Book","Childern Book","Cook Book","Politcal Book","Public Book"]
        bookStatusTF.optionArray = ["New","Used"]

     
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
        func cornerRadius(){
           
            nameLabelTextField.layer.cornerRadius = 10
            nameLabelTextField.layer.borderWidth = 1
            nameLabelTextField.layer.borderColor = UIColor.red.cgColor
            
            descriptionTextView.layer.cornerRadius = 10
            descriptionTextView.layer.borderWidth = 1
            descriptionTextView.layer.borderColor = UIColor.red.cgColor
            
           pricesTextField.layer.cornerRadius = 10
            pricesTextField.layer.borderWidth = 1
           pricesTextField.layer.borderColor = UIColor.red.cgColor
            
            addBtn.layer.cornerRadius = 10
            addBtn.layer.borderWidth = 1
            addBtn.layer.borderColor = UIColor.red.cgColor
      }
    func shadow(){
        addBtn.layer.shadowColor = UIColor.black.cgColor
        addBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        addBtn.layer.shadowRadius = 8
        addBtn.layer.shadowOpacity = 0.5
        addBtn.layer.masksToBounds = false
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        self.imagePicker.present(from: self.view)
    }
    @IBAction func addPressed(_ sender: UIButton) {
        self.book = Book.init(name: self.nameLabelTextField.text!, description: self.descriptionTextView.text!, section: self.sectionTF.text!, bookStatus: self.bookStatusTF.text!, price: self.pricesTextField.text!)
        self.saveBook(self.book)
    }
    func saveBook(_ book: Book) {
           let docData: [String: Any] = [
            "name": book.name,
            "description": book.description,
            "section":book.section,
            "bookStatus":book.bookStatus,
            "price":book.price,
            "userToken":Auth.auth().currentUser?.uid
           ]
        db.collection("Book").document().setData(docData) { err in
               if let err = err {
                   print("Error writing document: \(err)")
               } else {
                   print("Document successfully written!")
               }
           }
       }
}
extension AddBookViewController:ImagePickerDelegate{
    func didSelect(image: UIImage?) {
            if let image = image{
                addImageBook.image = image
            }
    }
}


