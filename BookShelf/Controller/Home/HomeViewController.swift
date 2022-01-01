//
//  HomeViewController.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//

import UIKit
import Firebase
class HomeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        }
     

   
    @IBAction func LoginCheck(_ sender: UIBarButtonItem) {
   
        if (Auth.auth().currentUser?.uid != nil){
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            self.navigationController?.show(vc, sender: self)
            print("User Login")
            
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
              self.navigationController?.show(vc, sender: self)
            print("User Not Login")
        }
//        }else if(Auth.auth().currentUser?.uid == nil) {
//            self.performSegue(withIdentifier: "UserNotLogin", sender: self)
//            print("UserNotLogin")
//        }
//
    }
    
}
