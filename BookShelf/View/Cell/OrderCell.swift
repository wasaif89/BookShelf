//
//  OrderCell.swift
//  BookShelf
//
//  Created by Abu FaisaL on 20/05/1443 AH.
//

import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var customerID: UILabel!
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
