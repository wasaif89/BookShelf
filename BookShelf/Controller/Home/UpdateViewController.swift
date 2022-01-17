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
//import FirebaseFirestoreSwift
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
   
    var book:Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBtn.cmShadow()
        sectionTextField.optionArray = ["Islmic Book","Childern Book","Cook Book","Educational Book","Other Book"]
        sectionTextField.backgroundColor = .secondarySystemBackground
        sectionTextField.rowBackgroundColor = .secondarySystemBackground
        
        bookStatusTextField.optionArray = ["New","Used"]
        bookStatusTextField.backgroundColor = .secondarySystemBackground
        bookStatusTextField.rowBackgroundColor = .secondarySystemBackground
        
        nameLabelTextField.text = book?.name
        descriptionTextView.text = book?.description
        sectionTextField.text = book?.section
        bookStatusTextField.text = book?.bookStatus
        pricesTF.text = book?.price
        updateImageBook.downloadFromURL(book?.image)
      
        print("Selected book \(book?.id)")

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
        let userReference = db.collection("User").document(Auth.auth().currentUser!.uid)
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
                    storgeProfileRef.downloadURL(completion:  { [self] (url, error) in
                        if let metaImageUrl = url?.absoluteString{
                           print(metaImageUrl)
                            
                            let bookRef = db.collection("Book").document((book?.id)!)
                                bookRef.updateData([
                                "name":nameLabelTextField.text,
                                "description":descriptionTextView.text ,
                                "section":sectionTextField.text ,
                                "bookStatus":bookStatusTextField.text,
                                "price":pricesTF.text,
                                "image":metaImageUrl,
                                "BookID": book?.id
                                 ])
                            { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                        }
                    })
            })
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
