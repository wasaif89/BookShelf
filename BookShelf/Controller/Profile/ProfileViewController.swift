//
//  ProfileViewController.swift
//  BookShelf
//
//  Created by Abu FaisaL on 09/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    var user = [User]()
    let db = Firestore.firestore()
   
    override func viewDidLoad() {
            super.viewDidLoad()
            readUsers()
            conerReduis()
        }
        func conerReduis(){
            nameLabel.layer.cornerRadius = 15
            nameLabel.layer.borderWidth = 1
            nameLabel.layer.borderColor =  UIColor(red:208/255, green:44/255, blue:166/255, alpha: 100).cgColor
            emailLabel.layer.cornerRadius =  15
            emailLabel.layer.borderWidth = 1
            emailLabel.layer.borderColor =  UIColor(red:208/255, green:44/255, blue:166/255, alpha: 100).cgColor
            phoneNumberLabel.layer.cornerRadius = 15
            phoneNumberLabel.layer.borderWidth = 1
            phoneNumberLabel.layer.borderColor =  UIColor(red:208/255, green:44/255, blue:166/255, alpha: 100).cgColor
            addressLabel.layer.cornerRadius = 15
            addressLabel.layer.borderWidth = 1
            addressLabel.layer.borderColor =  UIColor(red:208/255, green:44/255, blue:166/255, alpha: 100).cgColor
        }
    // get infrmation data user from firebase
        func readUsers(){
             if  let user = Auth.auth().currentUser?.uid{
                 let docRef = db.collection("Users").document(user)
                 docRef.getDocument { (document, error) in
                     if let document = document, document.exists {
                         let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                         self.nameLabel.text = document.data()?["name"] as? String
                         self.emailLabel.text = document.data()?["email"] as? String
                         _ = User(name: self.nameLabel.text, email: self.emailLabel.text, phoneNumber: self.phoneNumberLabel.text, latitude: nil,longitude: nil)
                         print("Document data")
                     } else {
                        print("Document does not exist\(error?.localizedDescription)")
                     }
                 }
             }
         }
    }

