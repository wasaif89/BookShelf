//
//  UpdateProfile.swift
//  BookShelf
//
//  Created by Abu FaisaL on 23/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestore

class UpdateProfileVC: UIViewController {
    @IBOutlet weak var updateNameTF: UITextField!
    @IBOutlet weak var updateEmailTF: UITextField!
    @IBOutlet weak var updatePhoneNumberTF: UITextField!
    @IBOutlet weak var updatePasswordTF: UITextField!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    @IBAction func updatePressed(_ sender: UIButton) {
        Auth.auth().currentUser?.updateEmail(to: updateEmailTF.text!) { error in
            if error == nil{
               print("Email Successful")
            
          }else{
               print("error\(error?.localizedDescription)")
        }
    }
     
        let washingtonRef = db.collection("Users").document(Auth.auth().currentUser!.uid)

        washingtonRef.updateData([
            "name": updateNameTF.text,
            "phoneNumber": updatePhoneNumberTF.text,
            "email": updateEmailTF.text
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }

    Auth.auth().currentUser?.updatePassword(to: updatePasswordTF.text!) { (error) in
        if error == nil{
           print("Password Successful")
        
      }else{
           print("error\(error?.localizedDescription)")
    }
}
}
 }

   

