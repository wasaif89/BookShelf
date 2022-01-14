//
//  LoginViewController.swift
//  BookShelf
//

import UIKit
import Firebase
import CoreLocation
import FirebaseAuth


class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pic1")!)
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
