//
//  SignUpViewController.swift
//  BookShelf
//


import UIKit
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var signUpBtn: UIButton!
    
    let db = Firestore.firestore()
    var user:User!
       
    
    override func viewDidLoad() {
            super.viewDidLoad()
            cornerRadius()
            shadow()
        }
    func cornerRadius(){
                userNameTextField.layer.cornerRadius = 20
                userNameTextField.layer.borderWidth = 1
                userNameTextField.layer.borderColor = UIColor.red.cgColor
                emailTextField.layer.cornerRadius = 20
                emailTextField.layer.borderWidth = 1
                emailTextField.layer.borderColor = UIColor.red.cgColor
                passwordTextField.layer.cornerRadius = 20
                passwordTextField.layer.borderWidth = 1
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                signUpBtn.layer.cornerRadius = 20
                signUpBtn.layer.borderWidth = 1
                signUpBtn.layer.borderColor = UIColor.red.cgColor
          }

        func shadow(){
            signUpBtn.layer.shadowColor = UIColor.black.cgColor
            signUpBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
            signUpBtn.layer.shadowRadius = 8
            signUpBtn.layer.shadowOpacity = 0.5
            signUpBtn.layer.masksToBounds = false
        }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                    if error == nil{
                        self.user = User.init(name: self.userNameTextField.text!, email: self.emailTextField.text!)
                        self.saveUser(self.user)
                  
                        print("Sign Up Successful")
                    }else{
                        print("Error\(error?.localizedDescription)")
                    }
            }
        }
        func saveUser(_ user: User) {
               let docData: [String: Any] = [
                "name": user.name,
                "email": user.email
               ]
               db.collection("Users").document(Auth.auth().currentUser!.uid).setData(docData) { err in
                   if let err = err {
                       print("Error writing document: \(err)")
                   } else {
                       print("Document successfully written!")
                   }
               }
           }
    }
