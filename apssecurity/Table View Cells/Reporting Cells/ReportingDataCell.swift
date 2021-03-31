//
//  ReportingDataCell.swift
//  apssecurity
//
//  Created by Smeet Chavda on 2020-11-23.
//

import UIKit

class ReportingDataCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    var vc: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(indexPath: IndexPath, name: String, area: String, shiftTime: String, vehicleUnit: String, address: String, vc: UIViewController) {
        self.vc = vc
        if indexPath.row == 1 || indexPath.row == 3 {
            self.accessoryType = .disclosureIndicator
        } else {
            self.accessoryType = .none
        }
        switch indexPath.row {
        case 0:
            lblTitle.text = "Officer Name"
            lblValue.text = name
        case 1:
            lblTitle.text = "Patrol Area"
            lblValue.text = area
        case 2:
            lblTitle.text = "Shift Start"
            lblValue.text = shiftTime
        case 3:
            lblTitle.text = "Vehicle Unit"
            lblValue.text = vehicleUnit
        case 4:
            lblTitle.text = "Address"
            lblValue.text = address
        default:
            break
        }
    }
    
    func setDataForEnterSite(indexPath: IndexPath, site: String, time: String, address: String, attendenceType: String, checkType: String, timeOfAlarmAct: String, vc: UIViewController) {
        self.vc = vc
        
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 5 {
            self.accessoryType = .disclosureIndicator
        } else {
            self.accessoryType = .none
        }
        self.lblValue.backgroundColor = .white
        self.lblValue.textAlignment = .right
        self.lblValue.corner_Radius = 0
        switch indexPath.row {
        case 0:
            lblTitle.text = "Site"
            lblValue.text = site
        case 1:
            lblTitle.text = ""
            lblValue.text = "Read Site Brief"
            self.lblValue.textAlignment = .center
            self.lblValue.backgroundColor = .systemYellow
            self.lblValue.corner_Radius = 15
        case 2:
            lblTitle.text = "Time on Site"
            lblValue.text = time
        case 3:
            lblTitle.text = "Address"
            lblValue.text = address
        case 4:
            lblTitle.text = "Attendence Type"
            lblValue.text = attendenceType
        case 5:
            lblTitle.text = "Check Type"
            lblValue.text = checkType
        case 6:
            lblTitle.text = "Enter Time of alarm activation"
            lblValue.text = timeOfAlarmAct
        default:
            lblTitle.text = ""
            lblValue.text = ""
            break
        }
    }

}
