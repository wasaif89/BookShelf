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
    let orderNumber:String?
    let customerID:String?
    let bookName:String?
    let prices:String?
    let user: DocumentReference? = nil
}

