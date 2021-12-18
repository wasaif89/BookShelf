//
//  LoginViewController.swift
//  BookShelf
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            cornerRadius()
            shadow()
        }
            func cornerRadius(){
                emailTextField.layer.cornerRadius = 20
                emailTextField.layer.borderWidth = 1
                emailTextField.layer.borderColor = UIColor.red.cgColor
                passwordTextField.layer.cornerRadius = 20
                passwordTextField.layer.borderWidth = 1
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                forgetBtn.layer.cornerRadius = 20
                forgetBtn.layer.borderWidth = 1
                forgetBtn.layer.borderColor = UIColor.red.cgColor
                loginBtn.layer.cornerRadius = 20
                loginBtn.layer.borderWidth = 1
                loginBtn.layer.borderColor = UIColor.red.cgColor
          }
        func shadow(){
            loginBtn.layer.shadowColor = UIColor.black.cgColor
            loginBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
            loginBtn.layer.shadowRadius = 8
            loginBtn.layer.shadowOpacity = 0.5
            loginBtn.layer.masksToBounds = false
            forgetBtn.layer.shadowColor = UIColor.black.cgColor
            forgetBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
            forgetBtn.layer.shadowRadius = 8
            forgetBtn.layer.shadowOpacity = 0.5
            forgetBtn.layer.masksToBounds = false
        }
    
    @IBAction func loginPreesed(_ sender: UIButton) {
            Auth.auth().signIn(withEmail: emailTextField.text!
                               , password: passwordTextField.text!) { [weak self] authResult, error in
                guard let self = self else { return }
                if error == nil{
                    print("Login Successful")
                }else{
                    print("error\(error?.localizedDescription)")
                }
            }
        }
    }
    


