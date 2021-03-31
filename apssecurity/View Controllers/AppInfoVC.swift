//
//  AppInfoVC.swift
//  apssecurity
//
//  Created by Smeet Chavda on 2020-12-01.
//

import UIKit

class AppInfoVC: UIViewController {
    
    @IBOutlet weak var lblAppInfo: UILabel!
    
    var strAppInfo = """

Australasian Protective Services is an organization that provides property security services to their clients. The organization appoints users to physically go to the client's address and keep a check on their property from time to time. They have to submit a report for every site they visit and take action if any they encounter any unusual activity happening there.

APS Security is an application developed and curated for this organization to make this whole process hassle-free and easier to use and understand. The purpose of this application is to keep track and records of the surveillance by its users. When user opens the application, they have to login, then enter details related to themselves, the vehicle they are going to use, and choose the site for supervision. At later stages in the application, they also have to enter all the details and images related to the property they visit during their shift in the application. There is a functionality for emergency surveillance in the application where the users get notified about the incident. The user who is nearest to the site goes for supervision and reports about the unusual activity. Before commencing the patrol, the user has to enter some more details. All of the site details are stored in the company's database to maintain a record. This application uses real-time location, address, and time at different stages for authenticity. This application is secure because only those who are given the login credentials from the security firm can access it.

This application is 100% original and authentic as it is made for Australasian Protective Services exclusively.

    1. Step 1- User enters his/her credentials (login id, password) to login to the system.
        · User name
        · Password
        Then clicks on “Login” Button

    2. Step 2- User enters details of the shift.
        · User name(auto-fill)
        · Shift start (auto-fill)
        · Patrol area
        · Vehicle unit
        · Start location(auto-fill)
        · Address(auto-fill)
        · Start km
        · Shift start checklist
            o Attended 15 minutes prior to the shift.
            o Full Uniform On
            o All allocated equipment checked and working fine.
            o Car in clean condition inside & outside.
            o Car not damaged inside & outside.
        · Add comments(if any)
        · Add Inspection images(if any)
        Then click on “Commence Patrols”.

    3. Step 3- User either clicks on enter site or finish.

    4. Step 4- After clicking on “Enter Site” user enters all the site details.
        · Site Name
        · Time on site(auto-fill)
        · GPS location(auto-fill)
        · Address(auto-fill)
        · Attendance type. If Alarm Response is selected
            o time of alarm activation
        · Check type
        · Any person on site. If yes,
            o Vehicle Rego
            o Vehicle Description
            o Full Name
            o Relationship with site
            o Company Name
            o Reason for presence
            o Additional details
        · Any damage on site, if yes
            o Activity type
            o Damage details
            o Police informed, if yes
                § Details of police user & station
            o After hours informed, if yes
                § Additional details
        · Any equipment exposed
            o Details
        · All locked & secured now
        · Site armed now
        · Additional Details
        · Add Photos
        Then click on Submit Details Button.

    5. Step 5-User views the auto generated date and time on screen and clicks on Leave Site Button.

    6. Step 6-User clicks on “Enter Site” Button and repeats step 4 and step 5 or clicks on “Finish Patrols” Button.

    7. Step 7-User fills a form before ending his shift.
        · User Name(auto-fill)
        · Shift Start(auto-fill)
        · Patrol area
        · Vehicle unit
        · Finish location(auto-fill)
        · Address(auto-fill)
        · Finish km
        · Shift completion checklist
            o I have completed my shift as per the allocated roaster schedule
            o All details provided are true and correct
            o No damage to the work car inside & outside
            o The work car inspected properly & is in a safe condition
            o A full uniform throughout my shift
            o No damage to the allocated equipment
        · Add comments
        · Upload Image
        Then click on “Conclude Shift” Button.

8. Notification- This is the feature that is present in the Main Menu, where the user receives a notification about an urgent surveillance on a site that has encountered any unusual activity. It also has the location of the site mentioned in it.

"""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "App Info"
        lblAppInfo.text = strAppInfo
    }
    
}
