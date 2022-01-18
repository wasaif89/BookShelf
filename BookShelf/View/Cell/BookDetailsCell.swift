//
//  BookDetailsCell.swift
//  BookShelf
//
//  Created by Abu FaisaL on 15/06/1443 AH.
//

import UIKit

class BookDetailsCell: UITableViewCell {

    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookDescripiton: UILabel!
    @IBOutlet weak var bookStatus: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookPrices: UILabel!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
