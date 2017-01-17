//
//  EnterCompetitionTableViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 31/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Eureka

class EnterCompetitionTableViewController: FormViewController {

    var competition: Competition?
    var eventId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let question = competition?.question {
            form
                +++ Section(question)
                
                +++ Section()
                <<< TextAreaRow("answer") { row in
                    row.title = "*Your Answer"
                    row.placeholder = "Write your answer here"
                    row.textAreaHeight = .Dynamic(initialTextViewHeight: 200)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterCompetitionButton(sender: UIBarButtonItem) {
        let params = prepareDataForForm()
        
        if params["competition_answer"] != nil {
            print("not blank")
            sendCompetitionDataToOTH(params)
        } else {
            alertUser()
        }
    }
    
    func alertUser() {
        let alertController = UIAlertController(title: "Competition Information", message: "Answer must not be blank", preferredStyle: .ActionSheet)
        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func sendCompetitionDataToOTH(params: [String: String]) {
        OTHService.sharedInstance.postDataToOTH("competition/enter", parameters: params) { (dictionary) in
            print(dictionary)
            self.performSegueWithIdentifier("back_to_competition_detail", sender: nil)
        }
    }
    
    func prepareDataForForm() -> [String: String] {
        
        let formValue = form.values()
        print(formValue)
        var params: [String: String] = [:]
        
        if let eventID = self.eventId {
            params["event_id"] = String(eventID)
        }
        
        params["member_id"] = String(NSUserDefaults.standardUserDefaults().integerForKey("id"))
        
        if let answer = formValue["answer"] as? String {
            params["competition_answer"] = answer
        }
        return params
    }

}
