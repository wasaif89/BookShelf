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
class UpdateViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var sectionTextField: UITextField!
    @IBOutlet weak var bookStausLabel: UILabel!
    @IBOutlet weak var bookStatusTextField: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var updateImageBook: UIImageView!
    var image: UIImage? = nil
    let db = Firestore.firestore()
    var user:User!
    var imagePicker: ImagePicker!
    var book:Book!
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        shadow()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
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
        self.imagePicker.present(from: self.view)
    }
    @IBAction func updatePressed(_ sender: UIButton) {
        self.book = Book.init(name: self.nameLabelTextField.text!, description: self.descriptionTextView.text!, section: nil, bookStatus: nil, price: "14")
        self.saveBook(self.book)
    }
    func saveBook(_ book: Book) {
           let docData: [String: Any] = [
            "name": book.name,
            "description": book.description,
            "section":book.section,
            "bookStatus":book.bookStatus,
            "price":book.price
           ]
        db.collection("Book").document(Auth.auth().currentUser!.uid).setData(docData) { err in
               if let err = err {
                   print("Error writing document: \(err)")
               } else {
                   print("Document successfully written!")
               }
           }
       }
}
extension UpdateViewController:ImagePickerDelegate{
    func didSelect(image: UIImage?) {
            if let image = image{
                updateImageBook.image = image
            }
    }
}
