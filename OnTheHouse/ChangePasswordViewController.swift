//
//  ChangePasswordViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 3/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Eureka
class ChangePasswordViewController: FormViewController {
    var member: [Member] = []
    var  paramChangePassword = [String]()
    let dataService = OTHService.sharedInstance
    var  password: String?
    var  confirmPassword: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        form
            +++ Section("Password should consist of atleast 8 characters")
            <<< PasswordRow() { row in
                row.title = "Password"
                row.tag = "password"
                
                }.onChange({
                    (row) in
                    self.password  = row.value
                })
            
            
            <<< PasswordRow() { row in
                row.title = "Confirm Password"
                row.tag = "passwordRepeat"
                
                
                }.onChange({
                    (row) in
                    self.confirmPassword = row.value
                })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    private func newPassword() -> [String: String] {
        let userID = NSUserDefaults.standardUserDefaults().integerForKey("id")
        
        return ["member_id": "\(userID)","password": password! , "password_confirm": confirmPassword!]
    }
    
    
    
    
    @IBAction func doneAction(sender: AnyObject) {
        if (self.password !=  self.confirmPassword) {
            showAlert()
        }
        else {
            OTHService.sharedInstance.postDataToOTH("member/change-password",parameters:newPassword(),completionHandler: { (dictionary) in
                Member(data: (dictionary["member"] as? [String: AnyObject])!)
                print(dictionary)
                self.performSegueWithIdentifier("unwindChangePassword", sender: nil)
            })
        }
    }
    
    @IBAction func showAlert() {
        let alertController = UIAlertController(title: "Log Out", message: "password and confirm password donot match", preferredStyle: .Alert)
        let OkAction = UIAlertAction(title: "OK", style: .Default) { (alertAction) in
            print("Make a call to the server to complete log out action")
        }
        alertController.addAction(OkAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
}