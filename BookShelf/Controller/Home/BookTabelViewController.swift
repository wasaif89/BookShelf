//
//  BookTabelViewController.swift
//  BookShelf
//
//  Created by Abu FaisaL on 10/05/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class BookTabelViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tabelView: UITableView!
    let db = Firestore.firestore()
    var book = [Book]()
    var bookImages = [UIImage]()
    var selectedBook : Book?

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
        cell.bookImage.downloadFromURL(book[indexPath.row].image)
        return cell
   }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabelView.deselectRow(at: indexPath, animated: true)
        selectedBook = book[indexPath.row]
        performSegue(withIdentifier: "UpdateSegue", sender: nil)
     }

     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let bookDoc = db.collection("Book").document(book[indexPath.row].id!)

            bookDoc.delete() { err in
                if let err = err {
                    print("Error removing document: \(err.localizedDescription)")
                } else {
                    print("Document successfully removed!")
                    tableView.reloadData()
                 
                }
            }
        } else  {
            print("error")
        }
    }


    func readBook(){
        let userReference = db.collection("Users").document(Auth.auth().currentUser!.uid)
        db.collection("Book").whereField("user", isEqualTo: userReference).addSnapshotListener { (querySnapshot, error) in
                self.book = []
                guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
            }
            print("Fetch user books", documents.count)
            for (index, doc) in documents.enumerated(){
                    print("Start decode book index:", index)

                   do{

                       print("Book document \(doc.documentID)")
                    let bookData = try doc.data(as: Book.self)
                       print("User book", bookData?.name)
                       if let bookData = bookData {
                            
                        self.book.append(bookData)
                        }
                       self.tabelView.reloadData()


                    }catch let error{
                        print("Error\(error.localizedDescription)")
                    }

            }
        }

}
    let updateSegueIdentifier = "UpdateSegue"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == updateSegueIdentifier {
            let destination =  segue.destination as! UpdateViewController
            destination.book = selectedBook
        }
    }
}
private var imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    
    func downloadFromURL(_ urlString: String?) {
        guard let urlString = urlString else {
            return
        }

        if let image = imageCache.object(forKey: urlString as NSString) {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if (error == nil) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                    imageCache.setObject(self.image!, forKey: urlString as NSString)
                }
            }
        }.resume()
    }
}
