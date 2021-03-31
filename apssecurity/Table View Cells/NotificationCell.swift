//
//  NotificationCell.swift
//  apssecurity
//
//  Created by Arpit Dhamane on 02/11/20.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var lblNotificationTitleOutlet: UILabel!
    @IBOutlet weak var lblNotificationTimeOutlet: UILabel!
    @IBOutlet weak var lblNotificationMessageOutlet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
