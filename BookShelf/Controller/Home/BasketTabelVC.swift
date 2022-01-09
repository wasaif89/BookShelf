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
    var selectedOrder : Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print("Basket")
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
        db.collection("Basket").whereField("userToken", isEqualTo: Auth.auth().currentUser?.uid).addSnapshotListener { (querySnapshot, error) in
            self.basket = []
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            print("Fetch user books", documents.count)
            for (index, doc) in documents.enumerated(){
                print("Start decode book index:", index)
                
                do{
                    
                    let bookData = try doc.data(as: Basket.self)
                    
                    if let bookData = bookData {
                        
                        self.basket.append(bookData)
                    }
                    self.tableView.reloadData()
                    
                    
                }catch let error{
                    print("Error\(error.localizedDescription)")
                }
                
            }
        }
    }
    let updateSegueIdentifier = "BuySegue"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == updateSegueIdentifier {
            let destination =  segue.destination as! BuyConfirmationVC
            destination.order = selectedOrder
        }
    }
}
