//
//  ReportingChecklistCell.swift
//  apssecurity
//
//  Created by Smeet Chavda on 2020-11-23.
//

import UIKit

class ReportingChecklistCell: UITableViewCell {
    
    @IBOutlet weak var checklistTitle: UILabel!
    @IBOutlet weak var btnChecklist: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checklistClicked(_ sender: UIButton) {
        self.btnChecklist.isSelected = !self.btnChecklist.isSelected
    }

}
