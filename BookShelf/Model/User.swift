//
//  User.swift
//  BookShelf
//
//  Created by Abu FaisaL on 08/05/1443 AH.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var id : String?
    let name : String?
    let email: String?
    let phoneNumber:String?
    let latitude: Double?
    let longitude: Double?
    
}
