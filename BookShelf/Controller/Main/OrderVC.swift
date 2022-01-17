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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        readOrder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "My Orders"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as! OrderCell
        cell.bookName.text = order[indexPath.row].bookName
        cell.prices.text = order[indexPath.row].prices
        cell.customerID.text = order[indexPath.row].customerID
        cell.orderNumber.text = "\(order[indexPath.row].orderNumber ?? 0 )"
        cell.date.text = order[indexPath.row].date
        
        return cell
    }
    func readOrder(){
        
        if Auth.auth().currentUser == nil {
            self.order = []
            self.tableView.reloadData()
            return
        }
        
//        let userReference = db.collection("Users").document(Auth.auth().currentUser!.uid)
//        db.collection("Order").whereField("userRef", isEqualTo:userReference).addSnapshotListener {
            db.collection("Order").whereField("userToken", isEqualTo:Auth.auth().currentUser!.uid).addSnapshotListener {(querySnapshot, error) in
            self.order = []
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            for doc in documents {
                do {
                    let orderData = try doc.data(as: Order.self)
                    if let orderData = orderData {
                        self.order.append(orderData)
                    }
                }catch let error{
                    print("Error\(error.localizedDescription)")
                }
            }
            self.tableView.reloadData()
        }
    }
}
