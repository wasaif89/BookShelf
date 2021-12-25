//
//  BuyConfirmationCell.swift
//  BookShelf
//
//  Created by Abu FaisaL on 21/05/1443 AH.
//

import UIKit

class BuyConfirmationCell: UITableViewCell {
    
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var prices: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
