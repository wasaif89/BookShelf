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
    var book:Book!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        shadow()
        sectionTF.optionArray = ["Islmic Book","Childern Book","Cook Book","Educational Book","Other Book"]
        bookStatusTF.optionArray = ["New","Used"]

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
        setupImage()
      }
            
    func setupImage() {
        addImageBook.contentMode = .scaleAspectFit
        addImageBook.layer.borderWidth = 1
        addImageBook.layer.masksToBounds = false
        addImageBook.layer.borderColor = UIColor.black.cgColor
        addImageBook.layer.cornerRadius = addImageBook.frame.height/2
        addImageBook.clipsToBounds = true
        addImageBook.isUserInteractionEnabled = true
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(presntPicker))
        addImageBook.addGestureRecognizer(tabGesture)
    }

    @objc func presntPicker() {
      let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        self.book = Book.init(name: self.nameLabelTextField.text!, description: self.descriptionTextView.text!, section: self.sectionTF.text!, bookStatus: self.bookStatusTF.text!, price: self.pricesTextField.text!)
        self.saveBook(self.book)
        guard let imageSelected = self.image else{
            print("image is nil")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4)
        else{ return}
        let storage = Storage.storage().reference(forURL: "gs://book-29caa.appspot.com")
          let storgeProfileRef = storage.child(UUID().uuidString)
          let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                storgeProfileRef.putData(imageData,metadata: metadata,completion: { (storgeMetaData, error) in
                    if error != nil {
                        print("erorr: \(error?.localizedDescription)")
                        return
                    }
                    storgeProfileRef.downloadURL(completion:  { (url, error) in
                        if let metaImageUrl = url?.absoluteString{
                           print(metaImageUrl)
                            
                            let washingtonRef = self.db.collection("Book").document()

                           washingtonRef.updateData([
                               "image":metaImageUrl

                          ]) { err in
                              if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                   print("Document successfully updated")
                               }
                           }
                            
                        }
                    })
                })
    }
    func saveBook(_ book: Book) {
           let docData: [String: Any] = [
            "name": book.name,
            "description": book.description,
            "section":book.section,
            "bookStatus":book.bookStatus,
            "price":book.price,
            "userToken":Auth.auth().currentUser?.uid,
            "bookID":db.collection("Book").document()]
        db.collection("Book").document().setData(docData) { err in
               if let err = err {
                 print("Error writing document: \(err)")
               } else {
                 print("Document successfully written!")
               }
          }
      }
 }
  extension AddBookViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{

      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
              image = imageSelected
              addImageBook.image = imageSelected
        }
          if let imageOriginal = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
              image = imageOriginal
              addImageBook.image = imageOriginal
        }

          picker.dismiss(animated: true, completion: nil)
    }
      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          picker.dismiss(animated: true, completion: nil)
      }
}


