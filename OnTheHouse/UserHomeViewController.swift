//
//  UserHomeViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 2/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Eureka

class UserHomeViewController: FormViewController {

     override func viewDidLoad() {
        super.viewDidLoad()
        CheckRow.defaultCellSetup = { cell, row in cell.tintColor = .orangeColor() }
        DateRow.defaultRowInitializer = { row in row.minimumDate = NSDate() }
        
        form
            +++ Section("User Settings")
            
                <<< ButtonRow("My membership") {
                    $0.title = $0.tag
                    $0.presentationMode = .SegueName(segueName: "myMemberShip", completionCallback: nil)
                }
            
            
                <<< ButtonRow("Change Details") {
                    $0.title = $0.tag
                    $0.presentationMode = .SegueName(segueName: "changeDetails", completionCallback: nil)
                }
            
            
                <<< ButtonRow("Change Password") {
                    $0.title = $0.tag
                    $0.presentationMode = .SegueName(segueName: "changePassword", completionCallback: nil)
                }
            
            +++ Section("Help and Support")
                <<< ButtonRow("Contact Us") {
                    $0.title = $0.tag
                    $0.presentationMode = .SegueName(segueName: "contactUs", completionCallback: nil)
                }
                <<< ButtonRow("FAQ") {
                    $0.title = $0.tag
                    $0.presentationMode = .SegueName(segueName: "faqSegue", completionCallback: nil)
                }
            
                <<< ButtonRow("Privacy Policy") {
                    $0.title = $0.tag
                    $0.presentationMode = .SegueName(segueName: "faqSegue", completionCallback: nil)
                }
            
                <<< ButtonRow("Terms & Conditions") {
                    $0.title = $0.tag
                    $0.presentationMode = .SegueName(segueName: "faqSegue", completionCallback: nil)
                }
            
            
            +++ Section()
                <<< ButtonRow() { (row: ButtonRow) -> Void in
                    row.title = "Log Out"
                    }  .onCellSelection({ (cell, row) in
                        self.showAlert()
                })
    }
    
    @IBAction func showAlert() {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure you want to log out ?", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "loggin_in")
            self.performSegueWithIdentifier("logOutSegue", sender: nil)
        })
        alertController.addAction(OKAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print(form.allRows[3].reload())
    }
    
    @IBAction func unwindToSettingHome(segue: UIStoryboardSegue) {
        
    }
}
