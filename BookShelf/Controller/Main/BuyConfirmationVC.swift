//
//  BuyConfirmationVC.swift
//  BookShelf
//
//  Created by Abu FaisaL on 21/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestore

class BuyConfirmationVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    let db = Firestore.firestore()
    var basket = [Basket]()
    var order:Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        readBuy()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basket.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuyConfirmationCell") as! BuyConfirmationCell
        cell.bookName.text = basket[indexPath.row].bookName
        cell.prices.text = basket[indexPath.row].prices
        return cell
    }
    @IBAction func buyPressed(_ sender: Any) {
        
        
    }
    func readBuy(){
        db.collection("Order").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                }
                    for doc in documents{
                        if (doc.data()["userToken"] as? String == Auth.auth().currentUser?.uid) {
                            let bookName = doc.data()["bookName"] as? String
                            let prices = doc.data()["priceBook"] as? String
                            let baskets = Basket.init(bookName: bookName, prices: prices)
                                self.basket.append(baskets)
                            }
                    }
            self.tableView.reloadData()
                }
        }
}
