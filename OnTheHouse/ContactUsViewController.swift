//
//  ContactUsViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 13/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Eureka

class ContactUsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form
            +++ Section()
            <<< TextRow("name") { row in
                row.title = "Name"
                if let firstName = NSUserDefaults.standardUserDefaults().stringForKey("firstName"), let lastName = NSUserDefaults.standardUserDefaults().stringForKey("lastName") {
                    
                    row.value = firstName + " " + lastName
                }
            }
            <<< TextRow("email") { row in
                row.title = "Email"
                if let email = NSUserDefaults.standardUserDefaults().stringForKey("email") {
                    row.value = email
                }
            }
            <<< TextAreaRow("message") { row in
                row.title = "Message"
                row.placeholder = "Write your meesage here"
                row.textAreaHeight = .Dynamic(initialTextViewHeight: 150)
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendForm(sender: UIBarButtonItem) {
        let formValue = getContactUsFormParameters()
        print(formValue)
        OTHService.sharedInstance.postDataToOTH("contact", parameters: formValue) { (dictionary) in
            print(dictionary)
            if !APIStatus.isSuccessfulResponse(dictionary) {
                if let alertList = APIStatus.retrieveErrorMessage(dictionary) {
                    if let alertController = APIStatus.showAlertMessageToUser(alertList) {
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
            } else {
                let alertController = UIAlertController(title: "Form Submitted", message: "Your question has been submitted.We will get back to as soon as possible", preferredStyle: .Alert)
                let OkAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                    self.performSegueWithIdentifier("unwindSettingsHome", sender: self)
                })
                alertController.addAction(OkAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    private func getContactUsFormParameters() -> [String: AnyObject] {
        let values = form.values()
        print("*")
        print(values)
        var params: [String: AnyObject] = [:]
        if let name = values["name"] as? String {
            params["name"] = name
        }
        
        if let email = values["email"] as? String {
            params["email"] = email
        }
        
        if let message = values["message"] as? String {
            params["message"] = message
        }
        return params
    }

}
