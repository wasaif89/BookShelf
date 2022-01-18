//
//  UpdateProfile.swift
//  BookShelf
//
//  Created by Abu FaisaL on 23/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation

class UpdateProfileVC: UIViewController {
    @IBOutlet weak var updateNameTF: UITextField!
    @IBOutlet weak var updateEmailTF: UITextField!
    @IBOutlet weak var updatePhoneNumberTF: UITextField!
    let db = Firestore.firestore()
    let locationManager = CLLocationManager()
    var user:User?
    var email:String = ""
    var name:String = ""
    var phone:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNameTF.text = name
        updateEmailTF.text = email
        updatePhoneNumberTF.text = phone
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)

     
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
                self.navigationController?.popViewController(animated: true)
                print("Document successfully updated")
            }
        }
}
    
 }

extension  UpdateProfileVC:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loacation = locations.last
        print("loacation : \(locationManager.location!.coordinate.latitude)")
        print("loacation : \(locationManager.location!.coordinate.longitude)")

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}



