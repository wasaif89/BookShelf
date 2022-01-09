//
//  IslmicTabelVC.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import iOSDropDown
class BooksVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tabelView: UITableView!
    let categories = ["All","Islmic Book","Childern Book","Cook Book","Educational Book","Other Book"]
    var selectedBook : Book?
    
        //
    

    @IBOutlet weak var categoriesTF: DropDown!
    
    let db = Firestore.firestore()
    var book = [Book]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
        categoriesTF.optionArray = ["All","Islmic Book","Childern Book","Cook Book","Educational Book","Other Book"]
        readBook()
        categoriesTF.didSelect { selectedText, index, id in
            print(selectedText, index, id)
            self.getBookByCategory(category:selectedText)

        }
    }
    func getBookByCategory(category: String){
        self.book.removeAll()
        if category == "All" {
            db.collection("Book").getDocuments { snapshot,error  in
                let alldocs = snapshot?.documents
                alldocs?.forEach({ doc in
                    do{
                        let bookData = try doc.data(as: Book.self)
                        self.book.append(bookData!)
                        self.tabelView.reloadData()
                    }catch{
                        print("error\(error.localizedDescription)")
                    }
                })
            }
        } else  {
            db.collection("Book").whereField("section", isEqualTo: category).getDocuments { snapshot, err in
                let alldocs = snapshot?.documents
                alldocs?.forEach({ doc in
                    do{
                        let bookData = try doc.data(as: Book.self)
                        self.book.append(bookData!)
                        self.tabelView.reloadData()
                    }catch{
                        print("error\(error.localizedDescription)")
                    }
                })
            }
        }
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
        selectedBook = book[indexPath.row]
        performSegue(withIdentifier: "BookSgeue", sender: nil)
    }
    
    func readBook(){
        db.collection("Book").addSnapshotListener { [self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            for doc in documents{
                do {
                    let book = try doc.data(as: Book.self)
                    if let book = book {
                        self.book.append(book)
                        self.tabelView.reloadData()
                    }
                } catch {
                    print("error read books \(error.localizedDescription)")
                }
            }
        }
    }
    
    let BookDetailsSegueIdentifier = "BookSgeue"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == BookDetailsSegueIdentifier {
            let destination =  segue.destination as! BookDetails
            destination.book = selectedBook
        }
    }
}
