//
//  SignUpViewController.swift
//  BookShelf
//


import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    let db = Firestore.firestore()
    var user:User!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.cmShadow()
        
    }
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
            if error == nil{
                self.user = User.init(name: self.userNameTextField.text!, email: self.emailTextField.text!, phoneNumber: self.phoneNumberTextField.text!,latitude: nil,longitude: nil )
                self.saveUser(self.user)
                print("Sign Up Successful")
                var alertVC = UIAlertController(title: "Welcome", message: nil, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
                //                       self.performSegue(withIdentifier: "GoToHomePage", sender: self)
            }else{
                print("Error\(error?.localizedDescription)")
                var alertVC = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    // save user data in firestore
    func saveUser(_ user: User) {
        let docData: [String: Any] = [
            "name": user.name,
            "email": user.email,
            "phoneNumber": user.phoneNumber,
            "time" : Date().timeIntervalSinceReferenceDate
            
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
