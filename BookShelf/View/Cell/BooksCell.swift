//
//  IslmicBooksCell.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//

import UIKit

class BooksCell: UITableViewCell {
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleBookLabel: UILabel!
    @IBOutlet weak var bookStatusLabel: UILabel!
    @IBOutlet weak var priceBookLabel: UILabel!
    @IBOutlet weak var setionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
