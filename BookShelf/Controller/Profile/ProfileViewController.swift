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
    
//        overrideUserInterfaceStyle = .light
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
                         self.phoneNumberLabel.text = document.data()? ["phoneNumber"] as? String
                         self.addressLabel.text = document.data()? ["latitude"] as? String
                         _ = User(name: self.nameLabel.text, email: self.emailLabel.text, phoneNumber: self.phoneNumberLabel.text, latitude: nil,longitude: nil)
                         print("Document data")
                     } else {
                        print("Document does not exist\(error?.localizedDescription)")
                     }
                 }
             }
         }
 
   @IBAction func signOutPressed(_ sender: UIButton) {
       
        let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
                print("Sign Out ")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "homePageID") as! HomeViewController
                  self.navigationController?.show(vc, sender: self)

            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
                
            }
                
            }
}

