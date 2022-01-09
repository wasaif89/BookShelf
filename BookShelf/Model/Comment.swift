//
//  Comment.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Comment: Codable {
    @DocumentID var id: String?
    let comment:String?
    let date: Timestamp?
    let book:DocumentReference?
    let user: DocumentReference?
    var byUser: String? = String()
//    let email:String?

}
