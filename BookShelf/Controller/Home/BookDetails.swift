//
//  BookDetails.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class BookDetails: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookDescripiton: UILabel!
    @IBOutlet weak var bookStatus: UILabel!
    @IBOutlet weak var bookPrices: UILabel!
    @IBOutlet weak var addBasketBtn: UIButton!
    @IBOutlet weak var comintTF: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bookImage: UIImageView!

    let db = Firestore.firestore()
    var user:User!
    var book:Book?
    var basket:Basket!
    var comment:Comment!
    var comments = [Comment]()
    var bookReference: DocumentReference!
    var userReference: DocumentReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Book Details"
        tableView.dataSource = self
        tableView.dataSource = self
        bookName.text = book?.name
        bookDescripiton.text = book?.description
        bookStatus.text = book?.bookStatus
        bookPrices.text = book?.price
        bookImage.downloadFromURL(book?.image)
        
        guard let bookID = book?.id else {
            return
        }
        bookReference = db.collection("Book").document(bookID)
        addBasketBtn.cmShadow()
        sendBtn.cmShadow()
        readComment()
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        userReference = db.collection("Users").document(userID)

    }
    
    func saveBasket(_ basket: Basket) {
        do {
            try db.collection("Basket").addDocument(from: basket, completion: { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            })
        } catch { }
    }

    func addComment(_ comment: Comment) {
        do {
            try db.collection("comment").document().setData(from: comment) { err in
                if err != nil {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        } catch {
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel!.text = comments[indexPath.row].byUser
        cell.detailTextLabel!.text = comments[indexPath.row].comment
        return cell
    }
  
    func readComment(){
        
        self.db.collection("comment").whereField("book", isEqualTo: bookReference).addSnapshotListener { commentsDocs, err in
            self.comments.removeAll()
            print("Comments for this book", commentsDocs?.documents.count)
            
            
            if err == nil {
                guard let commentsDocs = commentsDocs?.documents else {return}
                
                for comment in commentsDocs {
                    
                    do {
                        
                        var comment = try comment.data(as: Comment.self)
                        comment?.user?.getDocument(completion: { userDoc, err in
                            if err == nil {
                                do {
                                    let commentByUser = try userDoc?.data(as: User.self)
                                    comment?.byUser = commentByUser?.name
                                    self.comments.append(comment!)
                                    self.tableView.reloadData()
                                } catch {
                                    print("cannot decode comment by user", error.localizedDescription)
                                }
                            }
                        })
                        
                    } catch {
                        print("Cannot decode comment", error.localizedDescription)
                    }
                }
                
            }
        }

    }

    @IBAction func addBasketPressed(_ sender: UIButton) {
        if ((Auth.auth().currentUser?.uid) != nil){
            self.basket = Basket.init(bookName: self.bookName.text!, prices: self.bookPrices.text!,bookRef: bookReference ,userRef: userReference)
            self.saveBasket(self.basket)
            var alertVC = UIAlertController(title: "added to the basket", message: nil, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "User Not Login", message: "Please Login to Add Book To Basket", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert,animated: true,completion: nil)
            print("User Not Login")
        }

        
    }

        @IBAction func sendPressed(_ sender: UIButton) {
           if (Auth.auth().currentUser?.uid != nil){
                self.comment  =  Comment(id: nil, comment: self.comintTF.text!, date: Timestamp(date: Date()), book: bookReference, user: userReference)
                self.addComment(self.comment)
           }
            else{
                let alert = UIAlertController(title: "User Not Login", message: "Please Login to Add Comment", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert,animated: true,completion: nil)

                print("User Not Login")
            }

        }
    
    @IBAction func checkBasket(_ sender: UIBarButtonItem) {
        if (Auth.auth().currentUser?.uid != nil){
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "BasketID") as! BasketTabelVC
            self.navigationController?.show(vc, sender: self)
            print("User Login")
            
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
              self.navigationController?.show(vc, sender: self)
            print("User Not Login")
        }
    }
}

