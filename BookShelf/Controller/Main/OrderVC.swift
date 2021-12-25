//
//  OrderVC.swift
//  BookShelf
//
//  Created by Abu FaisaL on 20/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestore

class OrderVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var order = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        readOrder()

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
        cell.bookName.text = order[indexPath.row].bookName
        cell.prices.text = order[indexPath.row].prices
        cell.customerID.text = order[indexPath.row].customerID
        cell.orderNumber.text = order[indexPath.row].orderNumber
        return cell
    }
    func readOrder(){
        db.collection("Order").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                }
                    for doc in documents{
                        if (doc.data()["userToken"] as? String == Auth.auth().currentUser?.uid) {
                            let bookName = doc.data()["bookName"] as? String
                            let prices = doc.data()["priceBook"] as? String
                            let orderNumber = doc.data()["orderNumber"] as? String
                            let customerID = doc.data()["customerID"] as? String
                            let orders = Order.init(orderNumber: orderNumber, customerID: customerID, bookName: bookName, prices: prices)
                                self.order.append(orders)
                            }
                    }
            self.tableView.reloadData()
                }
        }
}
