//
//  CompetitionTableViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 26/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class CompetitionTableViewController: UITableViewController {
    var competitionData: [Event] = []
    var progressIndicator: UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProgressIndicator()
        self.navigationItem.title = "Competitions"
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "EventDetailCustomViewCell", bundle: nil), forCellReuseIdentifier: "eventMasterCell")
        tableView.estimatedRowHeight = 44.0
        OTHService.sharedInstance.getDataFromOTH("events/current") { (dictionary) in
            self.progressIndicator?.stopAnimating()
            self.competitionData = DataFormatter.getListOfEvents(dictionary).filter({ $0.isCompetition == true })
            self.tableView.reloadData()
        }
    }
    
    func configureProgressIndicator() {
        progressIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        progressIndicator?.color = UIColor.blackColor()
        progressIndicator?.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        progressIndicator?.center = self.view.center
        progressIndicator?.hidesWhenStopped = true
        view.addSubview(progressIndicator!)
        progressIndicator?.bringSubviewToFront(view)
        progressIndicator?.startAnimating()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return competitionData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventMasterCell", forIndexPath: indexPath) as! MasterDetailTableViewCell
        
        let competitionObject = self.competitionData[indexPath.row]

        cell.FullPrice.text = competitionObject.priceRange
        cell.EventHeadingPrice.hidden = true
        cell.EventTitle.text = competitionObject.name
        cell.eventImage.layer.cornerRadius = 8
        cell.eventImage.clipsToBounds = true
        cell.eventImage.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.eventImage.layer.borderWidth = 4
        cell.eventImage.image = competitionObject.thumbNailImage
        cell.BronzeImage.hidden = competitionObject.bronzeLogoVisibility
        cell.GoldImage.hidden = competitionObject.goldLogoVisibility
        
        cell.selectionStyle = .None

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("detail_competition_segue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail_competition_segue" {
            let destinationController = segue.destinationViewController as! CompetitionDetailTableViewController
            if let selectedIndex = tableView.indexPathForSelectedRow {
                destinationController.masterEvent = self.competitionData[selectedIndex.row]
            }
        }
    }

}
