//
//  SiteBriefVC.swift
//  apssecurity
//
//  Created by phycom on 18/01/21.
//

import UIKit

class SiteBriefVC: UIViewController {

    var enterSiteVC: EnterSiteVC?
    @IBOutlet weak var txtSiteBrief: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Site Brief"
        txtSiteBrief.text = enterSiteVC?.selSiteBrief
        txtSiteBrief.isSelectable = true
        txtSiteBrief.isEditable = false
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
