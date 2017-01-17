//
//  PreferencesViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 2/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Eureka

class ChangeDetailsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form
            +++ Section()
            <<< ButtonRow("Personal Details") {
                $0.title = $0.tag
                $0.presentationMode = .SegueName(segueName: "personalDetailSegue", completionCallback: nil)
            }
            <<< ButtonRow("Address") {
                $0.title = $0.tag
                $0.presentationMode = .SegueName(segueName: "userAddress", completionCallback: nil)
            }
            <<< ButtonRow("Preferences") {
                $0.title = $0.tag
                $0.presentationMode = .SegueName(segueName: "userPreferences", completionCallback: nil)
            }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(sender)
        print("segueing")
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
    
    }
    



}
