//
//  ForgetPasswordVC.swift
//  BookShelf
//
//  Created by Abu FaisaL on 12/06/1443 AH.
//

import UIKit
import Firebase
class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var restPassordBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func restPasswordBtn(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: emailTF.text!) { error in
            if let error =  error{
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)

                print(error.localizedDescription)
            }else{
                
                    let alert = UIAlertController(title: "Successfully", message: "The Email has been sent", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
