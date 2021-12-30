//
//  LoginViewController.swift
//  BookShelf
//

import UIKit
import Firebase
import CoreLocation


class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    let locationManager = CLLocationManager()
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
                 self.performSegue(withIdentifier: "GoToHomePage", sender: nil)

              }else{
                   print("error\(error?.localizedDescription)")

                      print("Error\(error?.localizedDescription)")
                      var alertVC = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: .alert)
                      alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                      self.present(alertVC, animated: true, completion: nil)




                  //             }
//       var alertVC = UIAlertController(title: "Welcome back log in success", message: error?.localizedDescription, preferredStyle: .alert)
//                    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//                                      self.present(alertVC, animated: true, completion: nil)
//                                      }else{
//                                      var alertVC = UIAlertController(title: "Alert", message: "error", preferredStyle: .alert)
//                                          alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//                                                            self.present(alertVC, animated: true, completion: nil)
//
                    }
        }
    }
        
//        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){
//            result , error in
//            if (error == nil) {
//                let profilVC =
//                self.storyboard?.instantiateViewController(withIdentifier: "homePageID") as! HomeViewController
//                self.navigationController?.show(profilVC, sender: self)
//                print(result?.user.email ?? "")
//                print("Login Successful")
//            }else{
//                print(error?.localizedDescription ?? "")
//                print("Error\(error?.localizedDescription)")
//            }
//
//            }
//        }
}
extension  LoginViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loacation = locations.last
        print("loacation : \(locationManager.location!.coordinate.latitude)")
        print("loacation : \(locationManager.location!.coordinate.longitude)")

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
