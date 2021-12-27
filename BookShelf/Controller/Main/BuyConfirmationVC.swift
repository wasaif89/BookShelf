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
        readBasket()
        readUsers()
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
        self.order = Order.init(orderNumber: nil, customerID: Auth.auth().currentUser?.uid, bookName: nil, prices: nil)
        self.saveOrder(self.order)
        
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

    func readUsers(){
         if  let user = Auth.auth().currentUser?.uid{
             let docRef = db.collection("Users").document(user)
             docRef.getDocument { (document, error) in
                 if let document = document, document.exists {
                     let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                     self.name.text = document.data()?["name"] as? String
                     self.phoneNumber.text = document.data()?["phoneNumer"] as? String
                     self.address.text = document.data()?["address"] as? String
                     self.date.text = document.data()?["date"] as? String
                     _ = User(name: self.name.text, email: nil,address: self.address.text, phoneNumber: self.phoneNumber.text)
                     print("Document data")
                 } else {
                    print("Document does not exist\(error?.localizedDescription)")
                 }
             }
         }
     }
    func saveOrder(_ order: Order) {
           let docData: [String: Any] = [
            "orderNumber":order.orderNumber,
            "bookName": order.bookName,
            "prices": order.prices,
            "userToken":Auth.auth().currentUser?.uid,
            "bookID":db.collection("Book").document()]
        db.collection("Order").document().setData(docData) { err in
               if let err = err {
                 print("Error writing document: \(err)")
               } else {
                 print("Document successfully written!")
               }
          }
      }
}
