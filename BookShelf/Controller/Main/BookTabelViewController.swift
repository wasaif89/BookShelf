//
//  BookTabelViewController.swift
//  BookShelf
//
//  Created by Abu FaisaL on 10/05/1443 AH.
//

import UIKit
import Firebase
class BookTabelViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tabelView: UITableView!
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as! BookCell
        cell.nameBook.text = book[indexPath.row].name
        cell.descriptonBook.text = book[indexPath.row].description
        cell.priceBook.text = book[indexPath.row].price
        return cell
    }
    let updateSegueIdentifier = "UpdateViewController"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == updateSegueIdentifier,
           let destination =  segue.destination as? UpdateViewController,
           let BookIndex = tabelView.indexPathForSelectedRow?.row
        {
            destination.book = book[BookIndex]
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabelView.deselectRow(at: indexPath, animated: true)
        let selectRow = book[indexPath.row]
        print(selectRow)
        
    
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           book.remove(at: indexPath.row)
           let docID = db.collection("Book").document().documentID
            tableView.deleteRows(at: [indexPath], with: .fade)
            db.collection("Book").document(docID).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        } else  {
           print("error")
        }
    }

    
    func readBook(){
            db.collection("Book").addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
            }
                for doc in documents{
                    if (doc.data()["userToken"] as? String == Auth.auth().currentUser?.uid) {
                            let name = doc.data()["name"] as? String
                            let description = doc.data()["description"] as? String
                        let price = doc.data()["price"] as? String
                        let books  = Book.init(name: name, description: description, section: nil, bookStatus: nil, price: price)
                             self.book.append(books)
                            print("Document data")
                               
                        }
                }
                self.tabelView.reloadData()
            }
        }

}




