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

    let db = Firestore.firestore()
    var user:User!
    var book:Book?
    var basket:Basket!
    var comment:Comment!
    var comments = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.dataSource = self
        bookName.text = book?.name
        bookDescripiton.text = book?.description
        bookStatus.text = book?.bookStatus
        bookPrices.text = book?.price

        cornerRadius()
        shadow()
        readComment()
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
           let docData: [String: Any] = [
            "bookName":basket.bookName ,
            "prices":basket.prices ,
            "userToken":Auth.auth().currentUser!.uid
           ]
        db.collection("Basket").document().setData(docData) { err in
               if let err = err {
                   print("Error writing document: \(err)")
               } else {
                   print("Document successfully written!")
               }
           }
       }

    func addComment(_ comment: Comment) {
           let docData: [String: Any] = [
            "comment":comment.comment,
            "userToken":Auth.auth().currentUser!.uid
           ]
        db.collection("comment").document().setData(docData) { err in
               if let err = err {
                   print("Error writing document: \(err)")
               } else {
                   print("Document successfully written!")
               }
           }
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComintCell") as! CommentCell
        cell.userName.text = Auth.auth().currentUser?.email
        cell.comment.text = comments[indexPath.row].comment
        return cell
    }
  
    func readComment(){
        db.collection("comment").addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                }
                    for doc in documents{
//                        if (doc.data()["bookID"] as? String == "bookID" ){
//                            let comment = doc.data()["comment"] as? String
                        let comment = try! doc.data(as: Comment.self)
//                         let commints = Comment.init(comment: comment, bookID: nil)
                        if let comment = comment {
                                 self.comments.append(comment)
                        }
//                        }
                    }
                    
            self.tableView.reloadData()
                }
    }

    @IBAction func addBasketPressed(_ sender: UIButton) {
        self.basket = Basket.init(bookName: self.bookName.text!, prices: self.bookPrices.text!)
    }

    @IBAction func sendPressed(_ sender: UIButton) {
//        self.comment  =  Comment.init(comment: self.comintTF.text!, bookID: nil)
        self.comment  =  Comment(id: nil, comment: self.comintTF.text!, date: Timestamp(date: Date()), book: nil, user: nil)

        self.addComment(self.comment)

    }
}

