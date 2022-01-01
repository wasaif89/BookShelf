//
//  SignUpViewController.swift
//  BookShelf
//


import UIKit
import Firebase
import FirebaseFirestore
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
                phoneNumberTextField.layer.cornerRadius = 20
                phoneNumberTextField.layer.borderWidth = 1
                phoneNumberTextField.layer.borderColor = UIColor.red.cgColor
       
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
                        self.user = User.init(name: self.userNameTextField.text!, email: self.emailTextField.text!, phoneNumber: self.phoneNumberTextField.text!,latitude: nil,longitude: nil )
                        self.saveUser(self.user)
                        print("Sign Up Successful")
                        var alertVC = UIAlertController(title: "Welcome back log in success", message: "Welcome back log in success ", preferredStyle: .alert)
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
                "latitude":user.latitude,
                "longitude":user.longitude,
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
extension  SignUpViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]!) {
        let loacation = locations.last
        print("loacation : \(locationManager.location!.coordinate.latitude)")
        print("loacation : \(locationManager.location!.coordinate.longitude)")
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }

            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(placemark: pm)
                } else {
                    print("Problem with the data received from geocoder")
                }
            })
        }

        func displayLocationInfo(placemark: CLPlacemark) {
            if placemark != nil {
                //stop updating location to save battery life
                locationManager.stopUpdatingLocation()

                print(placemark.locality)
                print(placemark.country)

            }


    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

