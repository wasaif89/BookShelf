//
//  BasketTabelVC.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestore

class BasketTabelVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var basket = [Basket]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
         readBasket()

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basket.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell") as! BasketCell
        cell.nameBook.text = basket[indexPath.row].bookName
        cell.priceBook.text = basket[indexPath.row].prices
        return cell
    }
    func readBasket(){
        db.collection("Basket").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                }
                    for doc in documents{
                        if (doc.data()["userToken"] as? String == Auth.auth().currentUser?.uid) {
                                let name = doc.data()["nameBook"] as? String
                                let prices = doc.data()["priceBook"] as? String
                            let baskets = Basket.init(bookName: name, prices: prices)
                                self.basket.append(baskets)
                            }
                    }
            self.tableView.reloadData()
                }
        }
 }
