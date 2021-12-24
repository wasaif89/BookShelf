//
//  BookCell.swift
//  BookShelf
//
//  Created by Abu FaisaL on 10/05/1443 AH.
//

import UIKit
class BookCell: UITableViewCell {
    @IBOutlet weak var nameBook: UILabel!
    @IBOutlet weak var descriptonBook: UILabel!
    @IBOutlet weak var priceBook: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
