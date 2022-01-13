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
        cornerRadius()
        shadow()
        readComment()
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        userReference = db.collection("Users").document(userID)

    }

    func cornerRadius(){

        bookName.layer.cornerRadius = 10
        bookName.layer.borderWidth = 1
        bookName.layer.borderColor = UIColor.red.cgColor

        bookDescripiton.layer.cornerRadius = 10
        bookDescripiton.layer.borderWidth = 1
        bookDescripiton.layer.borderColor = UIColor.red.cgColor

        bookStatus.layer.cornerRadius = 10
        bookStatus.layer.borderWidth = 1
        bookStatus.layer.borderColor = UIColor.red.cgColor

        bookPrices.layer.cornerRadius = 10
        bookPrices.layer.borderWidth = 1
        bookPrices.layer.borderColor = UIColor.red.cgColor
        addBasketBtn.layer.cornerRadius = 10
        addBasketBtn.layer.borderWidth = 1
        addBasketBtn.layer.borderColor = UIColor.red.cgColor

        comintTF.layer.cornerRadius = 10
        comintTF.layer.borderWidth = 1
        comintTF.layer.borderColor = UIColor.red.cgColor

        sendBtn.layer.cornerRadius = 10
        sendBtn.layer.borderWidth = 1
        sendBtn.layer.borderColor = UIColor.red.cgColor
  }
func shadow(){
    addBasketBtn.layer.shadowColor = UIColor.black.cgColor
    addBasketBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
    addBasketBtn.layer.shadowRadius = 8
    addBasketBtn.layer.shadowOpacity = 0.5
    addBasketBtn.layer.masksToBounds = false

    sendBtn.layer.shadowColor = UIColor.black.cgColor
    sendBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
    sendBtn.layer.shadowRadius = 8
    sendBtn.layer.shadowOpacity = 0.5
    sendBtn.layer.masksToBounds = false
}
    func saveBasket(_ basket: Basket) {

        try! db.collection("Basket").addDocument(from: basket, completion: { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        })
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComintCell") as! CommentCell
        cell.userName.text = comments[indexPath.row].byUser
        cell.comment.text = comments[indexPath.row].comment
        cell.commentDate.text = comments[indexPath.row].date?.description
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
        
        self.basket = Basket.init(bookName: self.bookName.text!, prices: self.bookPrices.text!,bookRef: bookReference ,userRef: userReference)
        self.saveBasket(self.basket)
        var alertVC = UIAlertController(title: "added to the basket", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
        
    }

        @IBAction func sendPressed(_ sender: UIButton) {
            
            self.comment  =  Comment(id: nil, comment: self.comintTF.text!, date: Timestamp(date: Date()), book: bookReference, user: userReference)
            self.addComment(self.comment)

        }
    }

