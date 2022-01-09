//
//  BuyConfirmationVC.swift
//  BookShelf
//
//  Created by Abu FaisaL on 21/05/1443 AH.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class BuyConfirmationVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    let db = Firestore.firestore()
    var basket = [Basket]()
    var order:Order!
    var baskets:Basket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        readBasket()
        readUsers()
        cornerRadius()
        shadow()



    }
    func cornerRadius(){
        buyBtn.layer.cornerRadius = 20
        buyBtn.layer.borderWidth = 1
        buyBtn.layer.borderColor = UIColor.red.cgColor
    }
    func shadow(){
        buyBtn.layer.shadowColor = UIColor.black.cgColor
        buyBtn.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        buyBtn.layer.shadowRadius = 8
        buyBtn.layer.shadowOpacity = 0.5
        buyBtn.layer.masksToBounds = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basket.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuyConfirmationCell") as! BuyConfirmationCell
        cell.bookName.text = basket[indexPath.row].bookName
        cell.prices.text = basket[indexPath.row].prices
        return cell
    }
    func readBasket(){
        let userReference = db.collection("Basket").document(Auth.auth().currentUser!.uid)
        db.collection("Basket").whereField("userToken", isEqualTo: Auth.auth().currentUser?.uid).getDocuments { (querySnapshot, error) in
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
    
    
    func readUsers(){
        if  let user = Auth.auth().currentUser?.uid{
            let docRef = db.collection("Users").document(user)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    self.name.text = document.data()?["name"] as? String
                    self.phoneNumber.text = document.data()?["phoneNumber"] as? String
                    self.date.text = document.data()? ["date"] as? String
                    //                     self.address.text = document.data()? ["latitude"] as? String
                    _ = User(name:  self.name.text, email:nil, phoneNumber:  self.phoneNumber.text, latitude:  nil,longitude: nil)
                    print("Document data")
                } else {
                    print("Document does not exist\(error?.localizedDescription)")
                }
            }
        }
    }
    
    func saveOrder(_ order: Order) {
        let documentID = UUID().uuidString
        try! db.collection("Order").document(documentID).setData(from: order) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    

   
    @IBAction func buyPressed(_ sender: Any) {
        let date = Date()
        let date2 = DateFormatter()
        date2.dateStyle = .full
        date2.timeStyle = .full
        let dateTime =  date2.string(from: date)
        print(dateTime)
        basket.forEach { basketOrder in
            let newOrder = Order(id: nil, orderNumber: Int.random(in: 0..<10000), customerID: Auth.auth().currentUser?.email, bookName: basketOrder.bookName, prices: basketOrder.prices, date: dateTime, userToken: Auth.auth().currentUser?.uid, address: addressTF.text!, user: nil)
            self.saveOrder(newOrder)
            let basketIndex = self.basket.firstIndex { basket in
                return basket.bookName == basketOrder.bookName
            }
            guard let basketIndex = basketIndex else {
                return
            }
            // Add book reference to Order custom type
            
//            basket.book.delete()
            self.tableView.deleteRows(at: [IndexPath(row: basketIndex, section: 0)], with: .bottom)
            self.basket.remove(at: basketIndex)

//            tableView.reloadData()

            
        }
        db.collection("Basket").whereField("userToken", isEqualTo: Auth.auth().currentUser?.uid).getDocuments { querySnapshot, err in
            if err == nil {
                querySnapshot?.documents.forEach({ basket in
                    self.db.collection("Basket").document(basket.documentID).delete()
                })
            }
        }

//        self.order = Order.init(orderNumber: Int.random(in: 0..<10000) , customerID: Auth.auth().currentUser?.email, bookName:nil , prices:"baskets.prices", date: dateTime,userToken: Auth.auth().currentUser?.uid,address: addressTF.text! )
        let alert = UIAlertController(title: "Your request has been successfully sent", message: "Your request has been sent successfully, we will contact you to verify the data and send the request", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
