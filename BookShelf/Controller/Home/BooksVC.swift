//
//  IslmicTabelVC.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//
import UIKit
import Firebase
import FirebaseFirestore
class BooksVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tabelView: UITableView!
    let categories = ["Islmic Book","Childern Book","Cook Book","Educational Book","Other Book"]
    var isSearching = false
    
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BooksCell") as! BooksCell
        cell.titleBookLabel.text = book[indexPath.row].name
        cell.bookStatusLabel.text = book[indexPath.row].bookStatus
        cell.priceBookLabel.text = book[indexPath.row].price
        cell.setionLabel.text = book[indexPath.row].section
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabelView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        print(book[row])
    }
    
    let BookDetailsSegueIdentifier = "BookDetails"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == BookDetailsSegueIdentifier,
           let destination =  segue.destination as? BookDetails,
           let BookIndex = tabelView.indexPathForSelectedRow?.row
        {
            destination.book = book[BookIndex]
            
        }
    }
    
    func readBook(){
        db.collection("Book").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                }
                    for doc in documents{
                           
                                let name = doc.data()["name"] as? String
                                let status = doc.data()["bookStatus"] as? String
                                let price = doc.data()["price"] as? String
                                let section = doc.data()["section"] as? String
                                let books = Book.init(name: name, description: nil, section: section, bookStatus: status, price: price)
                                self.book.append(books)
                           
                    }
            self.tabelView.reloadData()
                }
        }
}
