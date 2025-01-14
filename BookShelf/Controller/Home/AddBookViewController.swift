//
//  AddBookViewController.swift
//  BookShelf
//
//  Created by Abu FaisaL on 09/05/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

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
        addBtn.cmShadow()
        sectionTF.optionArray = ["Islmic Book","Childern Book","Cook Book","Educational Book","Other Book"]
        sectionTF.backgroundColor = .secondarySystemBackground
        sectionTF.rowBackgroundColor = .secondarySystemBackground

        bookStatusTF.optionArray = ["New","Used"]
        bookStatusTF.backgroundColor = .secondarySystemBackground
        bookStatusTF.rowBackgroundColor = .secondarySystemBackground

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
    func addToDatabase(ref: DocumentReference, image: String?){
            self.book = Book.init(name: self.nameLabelTextField.text!, description: self.descriptionTextView.text!, section: self.sectionTF.text!, bookStatus: self.bookStatusTF.text!, image: image ?? "", price: self.pricesTextField.text!, user: ref)
        self.saveBook(self.book)
    }
    @IBAction func addPressed(_ sender: UIButton) {
        let userReference = db.collection("Users").document(Auth.auth().currentUser!.uid)
        guard let imageSelected = self.image else{
            print("image is nil")
            self.addToDatabase(ref: userReference, image: nil)
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else{ return }
        let storage = Storage.storage().reference(forURL: "gs://book-29caa.appspot.com")
          let storgeProfileRef = storage.child(UUID().uuidString)
          let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                storgeProfileRef.putData(imageData,metadata: metadata,completion: { (storgeMetaData, error) in
                    if error != nil {
                        print("erorr: \(error?.localizedDescription)")
                        return
                    } else {
                        print("Error upload image to cloud storage ", error?.localizedDescription)
                    storgeProfileRef.downloadURL(completion:  { [self] (url, error) in
                        if let metaImageUrl = url?.absoluteString{
                           print(metaImageUrl)
                            /// Add to db
                            self.addToDatabase(ref: userReference, image: metaImageUrl)

                        }
                    })
                    }
                })
    }
    func saveBook(_ book: Book) {
        let documentID = UUID().uuidString
        do {
            try db.collection("Book").document(documentID).setData(from: book) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } catch {
            print (error.localizedDescription)
        }
    }
 }
  extension AddBookViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{

      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
              image = imageSelected
              addImageBook.image = imageSelected
          } else {
              if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                  image = imageOriginal
                  addImageBook.image = imageOriginal
            }
          }
          

          picker.dismiss(animated: true, completion: nil)
    }
      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          picker.dismiss(animated: true, completion: nil)
      }
}


