//
//  HomeViewController.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var R_SlideView: UIView!
    @IBOutlet weak var L_SlideView: UIView!
    
    var rMenuShowing = true
    var lMenuShowing = true
    
    @IBOutlet weak var islamicBtn: UIButton!
    @IBOutlet weak var educationalBtn: UIButton!
    @IBOutlet weak var chlidrensBtn: UIButton!
    @IBOutlet weak var cookBtn: UIButton!
    @IBOutlet weak var otherBooksBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        L_SlideView.layer.shadowOpacity = 2
        islamicBtn.setButton()
        educationalBtn.setButton()
        chlidrensBtn.setButton()
        cookBtn.setButton()
        otherBooksBtn.setButton()
    }
    @IBAction func R_SlideMenu(_ sender: Any) {
        if (rMenuShowing){
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.R_SlideView.frame.origin.x = 214
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.R_SlideView.frame.origin.x = 500
            }
       )}
        rMenuShowing = !rMenuShowing
    }
   @IBAction func L_SlideMenu(_ sender: Any) {
        if (lMenuShowing){
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.L_SlideView.frame.origin.x = 0
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.L_SlideView.frame.origin.x = -500
            }
       )}
        lMenuShowing = !lMenuShowing
    }
    
    @IBAction func profilePressed(_ sender: Any) {
        
        
    }
    
  
}
extension UIButton{
    func setButton(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
