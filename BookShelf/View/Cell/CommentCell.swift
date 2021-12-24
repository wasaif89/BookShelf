//
//  ComintCell.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/05/1443 AH.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var comment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

