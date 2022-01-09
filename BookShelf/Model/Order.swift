//
//  Order.swift
//  BookShelf
//
//  Created by Abu FaisaL on 21/05/1443 AH.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Order: Codable {
    @DocumentID var id: String?
    let orderNumber:Int?
    let customerID:String?
    let bookName:String?
//    let bookRef:DocumentReference?
    let prices:String?
    let date:String
    let userToken:String?
    let address:String?
    var user: DocumentReference? = nil
}

