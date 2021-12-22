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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectRow = book[indexPath.row]
        print(selectRow)
    }
//     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            book.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else  {
//           print("error")
//        }
//    }
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
//
//
//    func readBook(){
//         if  let user = Auth.auth().currentUser?.uid{
//             let docRef = db.collection("Book").document(user)
//             docRef.getDocument { (document, error) in
//                 if let document = document, document.exists {
//                    if let error = error {
//                        print(error.localizedDescription)
//                        return
//                    }
//                     let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                     let name = document.data()?["name"] as? String
//                    let description = document.data()?["description"] as? String
//                    let price = document.data()?["price"] as? String
//                     print(name)
//                    let books  = Book.init(name: name, description: description, section: nil, bookStatus: nil, price: price)
//                    self.book.append(books)
//                     print("Document data")
//                    self.tabelView.reloadData()
//                 } else {
//                    print("Document does not exist\(error?.localizedDescription)")
//                 }
//             }
//         }
//     }
}




