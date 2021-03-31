//
//  MenuCell.swift
//  apssecurity
//
//  Created by Arpit Dhamane on 02/11/20.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var imageMenuItem: UIImageView!
    @IBOutlet weak var lblMenuItemTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
