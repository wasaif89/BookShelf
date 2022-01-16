//
//  HomeViewController.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth
class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var pageControl:UIPageControl!
    @IBOutlet weak var collectionView:UICollectionView!
    
    var timer:Timer?
    var currentCellIndex = 0
    var arrPic = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3"),UIImage(named: "4")]

    func configureAppearance() {
        self.title = "Book Shelf"
        self.navigationController?.navigationBar.prefersLargeTitles = true 
//        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "Secondary")
        //self.navigationController?.navigationBar.barTintColor = UIColor(named: "Secondary")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        collectionView.delegate = self
            collectionView.dataSource = self
            pageControl.numberOfPages = arrPic.count
            startTimer()
                navigationItem.setHidesBackButton(true, animated: true)
        }
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
      }
      
      
      @objc func moveToNextIndex(){
        if currentCellIndex < arrPic.count - 1 {
          currentCellIndex += 1
        } else {
          currentCellIndex = 0
        }
        collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentPage = currentCellIndex
      }
      
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPic.count
      }
      
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCell", for: indexPath) as! HomeCell
          cell.imageCollection.image = arrPic[indexPath.row]
          cell.heightConstraint.constant = collectionView.frame.height
          cell.widthConstraint.constant = collectionView.frame.width
        return cell
      }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
      }
      
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
      }
    
    @IBAction func LoginCheck(_ sender: UIBarButtonItem) {
   
        if (Auth.auth().currentUser?.uid != nil){
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.show(vc, sender: self)
            print("User Login")
            
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
              self.navigationController?.show(vc, sender: self)
            print("User Not Login")
        }
    }
    
    @IBAction func basket(_ sender: UIBarButtonItem) {
        
             if (Auth.auth().currentUser?.uid != nil){
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "BasketID") as! BasketTabelVC
                 self.navigationController?.show(vc, sender: self)
                 print("User Login")
                 
             }else{
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                   self.navigationController?.show(vc, sender: self)
                 print("User Not Login")
             }
         }
}
