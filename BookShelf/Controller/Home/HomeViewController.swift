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
     
    }
   
    @IBAction func LoginCheck(_ sender: UIBarButtonItem) {
        if Auth.auth().currentUser?.uid == nil{
            self.performSegue(withIdentifier: "UserNotLogin", sender: self)
        }else {
            self.performSegue(withIdentifier: "UserLogin", sender: self)
        }
        
    }
    
}
