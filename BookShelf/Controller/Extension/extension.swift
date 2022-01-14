//
//  extention.swift
//  BookShelf
//
//  Created by Abu FaisaL on 11/06/1443 AH.
//

import Foundation
import UIKit
extension UIButton{

    func cmShadow(cornerRadius: CGFloat = 15,
                     borderWidth: CGFloat = 1,
                     
                     shadowColor: CGColor = UIColor.black.cgColor,
                     shadowOffset: CGSize = CGSize(width: 0.0, height: 6.0),
                     shadowRadius: CGFloat = 8,
                     shadowOpacity: Float = 0.5,
                     masksToBounds: Bool = false) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1

        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.masksToBounds = masksToBounds
      }
}
