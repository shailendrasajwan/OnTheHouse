//
//  EventRatingTableViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 12/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Cosmos

class EventRatingTableViewController: UITableViewController {
    
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var comment: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ratingBar.settings.updateOnTouch = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
