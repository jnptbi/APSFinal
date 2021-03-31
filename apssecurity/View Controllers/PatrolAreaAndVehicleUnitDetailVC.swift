//
//  PatrolAreaAndVehicleUnitDetailVC.swift
//  apssecurity
//
//  Created by Smeet Chavda on 2020-11-24.
//

import UIKit

class PatrolAreaAndVehicleUnitDetailVC: UIViewController ,UISearchBarDelegate{
    
    @IBOutlet weak var objTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isForPatrolArea = false
    
    var arrVehicleUnitList: [vehicleUnitList] = []
    var arrVehiclePatrolArea: [vehiclePatrolArea] = []
    
    var SearchBarValue:String!
    var searchActive : Bool = false
    
    var reportingVC: ReportingVC?
    var enterSiteVC: EnterSiteVC?
    var finishPatrolVC: FinishPatrolsVC?
    
    var index: Int?
    
    var arrSite: [IDSiteData] = []
    var arrCheck: [IDCheckData] = []
    var arrAttendance: [IDAttendanceData] = []
    var arrActivity: [IDActivityData] = []
    var arrRelation: [IDRelationData] = []
    
    var filteredArrSite: [IDSiteData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.isHidden = true
        
        objTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        if reportingVC != nil || finishPatrolVC != nil {
            self.title = isForPatrolArea ? "Patrol Area" : "Vehicle Unit"
        } else if enterSiteVC != nil {
            switch index {
            case 0: //For Site
                searchBar.isHidden = false
                self.title = "Site"
                break
            case 1: //For Site Brief
                self.title = "Site Brief"
                break
            case 4: //For Attendence Type
                self.title = "Attendence Type"
                break
            case 5: //For Check Type
                self.title = "Check Type"
                break
            case 10: //For Relation Type
                self.title = "Relationship"
                break
            case 11: //For Activity Type
                self.title = "Activity Type"
                break
            default:
                self.title = "Detail"
                break
            }
        }
    }
    
    
    // MARK -
    // MARK: - SearchBar Delegates
    // MARK:-
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        filteredArrSite.removeAll()
        searchBar.text = nil
        searchBar.resignFirstResponder()
        objTableView.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        objTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchActive = true;
        self.searchBar.showsCancelButton = true
        
        filteredArrSite.removeAll()
        
        DispatchQueue.global(qos: .background).async {
            
            self.filteredArrSite = self.arrSite.filter { (siteData: IDSiteData) -> Bool in
                return siteData.site_name.lowercased().contains(searchText.lowercased())
            }
            
            DispatchQueue.main.async {
                // Run UI Updates
                self.objTableView.reloadData()
            }
            
        }
    }
    
}
// MARK -
// MARK: - Table Delegates
// MARK:-

extension PatrolAreaAndVehicleUnitDetailVC : UITableViewDelegate, UITableViewDataSource{
    // MARK: - DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reportingVC != nil || finishPatrolVC != nil {
            return isForPatrolArea ? self.arrVehiclePatrolArea.count : self.arrVehicleUnitList.count
        } else if enterSiteVC != nil {
            switch index {
            case 0: //For Site
                if(searchActive) {
                    return filteredArrSite.count
                }else{
                    return arrSite.count
                }
            case 1: //For Site Brief
                return 1
            case 4: //For Attendence Type
                return arrAttendance.count
            case 5: //For Check Type
                return arrCheck.count
            case 10: //For Relation
                return arrRelation.count
            case 11: //For Activity
                return arrActivity.count
            default:
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        if reportingVC != nil {
            if isForPatrolArea {
                cell.textLabel?.text = self.arrVehiclePatrolArea[indexPath.row].patrolAreaName
                if reportingVC?.selPetrolAreaID == self.arrVehiclePatrolArea[indexPath.row].patrolID {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            } else {
                cell.textLabel?.text = self.arrVehicleUnitList[indexPath.row].vehicleName
                if reportingVC?.selVehicleUnitNumID == self.arrVehicleUnitList[indexPath.row].vehicleID {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        } else if finishPatrolVC != nil {
            if isForPatrolArea {
                cell.textLabel?.text = self.arrVehiclePatrolArea[indexPath.row].patrolAreaName
                if finishPatrolVC?.selPetrolAreaID == self.arrVehiclePatrolArea[indexPath.row].patrolID {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            } else {
                cell.textLabel?.text = self.arrVehicleUnitList[indexPath.row].vehicleName
                if finishPatrolVC?.selVehicleUnitNumID == self.arrVehicleUnitList[indexPath.row].vehicleID {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        } else if enterSiteVC != nil {
            switch index {
            case 0: //For Site
                if filteredArrSite.count != 0{
                    cell.textLabel?.text = self.filteredArrSite[indexPath.row].site_name
                    if self.enterSiteVC?.selSiteId == self.filteredArrSite[indexPath.row].site_id {
                        cell.accessoryType = .checkmark
                    } else {
                        cell.accessoryType = .none
                    }
                }else{
                    cell.textLabel?.text = self.arrSite[indexPath.row].site_name
                    if enterSiteVC?.selSiteId == self.arrSite[indexPath.row].site_id {
                        cell.accessoryType = .checkmark
                    } else {
                        cell.accessoryType = .none
                    }
                }
                break
            case 1: //For Site Brief
                cell.textLabel?.text = enterSiteVC?.selSiteBrief
                cell.textLabel?.numberOfLines = 0
                self.objTableView.separatorStyle = .none
                break
            case 4: //For Attendence Type
                cell.textLabel?.text = self.arrAttendance[indexPath.row].attendance_details
                if enterSiteVC?.selAttendenceTypeId == self.arrAttendance[indexPath.row].attendance_type_id {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                break
            case 5: //For Check Type
                cell.textLabel?.text = self.arrCheck[indexPath.row].check_type_details
                if enterSiteVC?.selCheckTypeId == self.arrCheck[indexPath.row].check_type_id {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                break
            case 10: //For Relation Type
                cell.textLabel?.text = self.arrRelation[indexPath.row].relationship_descript
                if enterSiteVC?.selRelationshipTypeId == self.arrRelation[indexPath.row].relationship_id {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                break
            case 11: //For Activity Type
                cell.textLabel?.text = self.arrActivity[indexPath.row].activity_details
                if enterSiteVC?.selActivityTypeId == self.arrActivity[indexPath.row].activity_id {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                break
            default:
                break
            }
        }
        return cell;
    }
    // MARK: - Delegate Methods
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if enterSiteVC != nil {
            if index == 1 {
                return UITableView.automaticDimension
            }
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if reportingVC != nil {
            if isForPatrolArea {
                reportingVC?.selPetrolAreaID = self.arrVehiclePatrolArea[indexPath.row].patrolID
                reportingVC?.selectedPatrolArea = self.arrVehiclePatrolArea[indexPath.row].patrolAreaName
            } else {
                reportingVC?.selVehicleUnitNumID = self.arrVehicleUnitList[indexPath.row].vehicleID
                reportingVC?.selectedVehicleUnit = self.arrVehicleUnitList[indexPath.row].vehicleName
            }
            reportingVC?.tblReportingData.reloadData()
            self.navigationController?.popViewController(animated: true)
        } else if finishPatrolVC != nil {
            if isForPatrolArea {
                finishPatrolVC?.selPetrolAreaID = self.arrVehiclePatrolArea[indexPath.row].patrolID
                finishPatrolVC?.selectedPatrolArea = self.arrVehiclePatrolArea[indexPath.row].patrolAreaName
            } else {
                finishPatrolVC?.selVehicleUnitNumID = self.arrVehicleUnitList[indexPath.row].vehicleID
                finishPatrolVC?.selectedVehicleUnit = self.arrVehicleUnitList[indexPath.row].vehicleName
            }
            finishPatrolVC?.tblFinishData.reloadData()
            self.navigationController?.popViewController(animated: true)
        } else if enterSiteVC != nil {
            if index != 1 {
                switch index {
                case 0: //For Site
                    if filteredArrSite.count != 0{
                        enterSiteVC?.selSiteId = self.filteredArrSite[indexPath.row].site_id
                        enterSiteVC?.selSite = self.filteredArrSite[indexPath.row].site_name
                        enterSiteVC?.selSiteBrief = self.filteredArrSite[indexPath.row].site_brief
                    }else{
                        enterSiteVC?.selSiteId = self.arrSite[indexPath.row].site_id
                        enterSiteVC?.selSite = self.arrSite[indexPath.row].site_name
                        enterSiteVC?.selSiteBrief = self.arrSite[indexPath.row].site_brief
                    }
                case 4: //For Attendence Type
                    enterSiteVC?.selAttendenceTypeId = self.arrAttendance[indexPath.row].attendance_type_id
                    enterSiteVC?.selAttendenceType = self.arrAttendance[indexPath.row].attendance_details
                case 5: //For Check Type
                    enterSiteVC?.selCheckTypeId = self.arrCheck[indexPath.row].check_type_id
                    enterSiteVC?.selCheckType = self.arrCheck[indexPath.row].check_type_details
                case 10: //For Relation Type
                    enterSiteVC?.selRelationshipTypeId = self.arrRelation[indexPath.row].relationship_id
                    enterSiteVC?.selRelationshipType = self.arrRelation[indexPath.row].relationship_descript
                case 11: //For Activity Type
                    enterSiteVC?.selActivityTypeId = self.arrActivity[indexPath.row].activity_id
                    enterSiteVC?.selActivityType = self.arrActivity[indexPath.row].activity_details
                default:
                    break
                }
                enterSiteVC?.tblUserData.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
