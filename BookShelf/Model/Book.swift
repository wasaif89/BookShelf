//
//  Book.swift
//  BookShelf
//
//  Created by Abu FaisaL on 10/05/1443 AH.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

struct Book : Codable {
    @DocumentID var id : String? = ""
    let name:String?
    let description:String?
    let section:String?
    var bookStatus:String?
    let image:String?
    let price:String?
    let user: DocumentReference?
}
