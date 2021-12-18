//
//  PolitcalTabelViewController.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//

import UIKit
import Firebase
import FirebaseFirestore

class PolitcalTabelViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tabelView: UITableView!
    let db = Firestore.firestore()
    var book = [Book]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
        readBook()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return book.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PoliticalBooksCell") as! PoliticalBooksCell
        cell.nameBook.text = book[indexPath.row].name
        cell.statusBook.text = book[indexPath.row].bookStatus
        cell.priceBook.text = book[indexPath.row].price
        
        return cell
    }
    func readBook(){
        db.collection("Book").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                }
                    for doc in documents{
                            if (doc.data()["section"] as? String == "Politcal Book") {
                                let name = doc.data()["name"] as? String
                                let status = doc.data()["bookStatus"] as? String
                                let price = doc.data()["price"] as? String
                                let books = Book.init(name: name, description: nil, section: nil, bookStatus: status, price: price)
                                self.book.append(books)
                            }
                    }
            self.tabelView.reloadData()
                }
            }
}
