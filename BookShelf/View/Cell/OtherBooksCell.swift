//
//  PublicBookCell.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//

import UIKit

class OtherBooksCell: UITableViewCell {
    @IBOutlet weak var nameBook: UILabel!
    @IBOutlet weak var statusBook: UILabel!
    @IBOutlet weak var priceBook: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
