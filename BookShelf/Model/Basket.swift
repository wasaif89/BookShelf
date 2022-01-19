//
//  Basket.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Basket: Codable {
    @DocumentID var id : String?
    let bookName:String?
    let prices:String?
    let bookRef: DocumentReference?
    let userRef: DocumentReference?
}
