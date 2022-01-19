//
//  LoginViewController.swift
//  BookShelf
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.cmShadow()

    }
 
    @IBAction func loginPreesed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!
                           , password: passwordTextField.text!) { [weak self] authResult, error in
            guard let self = self else { return }
            if error == nil{
                print("Login Successful")
                let vc =
                self.storyboard?.instantiateViewController(withIdentifier: "homePageID") as! HomeViewController
                self.navigationController?.show(vc, sender: self)
                
            }else{
                print("error\(error?.localizedDescription)")
                
                print("Error\(error?.localizedDescription)")
                var alertVC = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
                
            }
        }
    }
}
