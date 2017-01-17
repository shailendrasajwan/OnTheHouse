//
//  CompetitionDetailTableViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 30/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class CompetitionDetailTableViewController: UITableViewController {

    var event: EventImproved?
    var masterEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .None
        tableView.registerNib(UINib(nibName: "CompetitionImageView", bundle: nil), forCellReuseIdentifier: "image_cell")
        tableView.estimatedRowHeight = 44.0
        print("Show membership \(self.masterEvent?.memberShipLevelID)")
        print("Can user enter competion \(self.masterEvent?.canUserEnterCompetition())")
        
        guard let userID = NSUserDefaults.standardUserDefaults().valueForKey("id") as? Int else {
            return
        }
        if let eventID = masterEvent?.id {
            OTHService.sharedInstance.postDataToOTH("event/\(eventID)", parameters: ["member_id": userID]) { (dictionary) in
                if let eventDictionary = dictionary["event"] as? [String: AnyObject] {
                    self.event = EventImproved(data: eventDictionary)
                    self.tableView.reloadData()
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       if section == 3 {
            if let value = self.event?.eventShowList.count {
                print(value)
                return value
            }
            return 0
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let index = indexPath.row
        if section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("image_cell", forIndexPath: indexPath) as! CompetitionImageTableViewCell
            cell.competitionImageView.image = self.event?.thumbNailImage
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("event_name", forIndexPath: indexPath) as! CompetitionTitleTableViewCell
            cell.nameLabel.text = self.event?.name
            cell.nameLabel.textColor = UIColor.whiteColor()
            cell.backgroundColor = UIColor.lightGrayColor()
            cell.selectionStyle = .None
            return cell
        } else if section == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("event_show_detail", forIndexPath: indexPath) as! CompetitionShowInformationTableViewCell
            if let shows = self.event?.eventShowList {
                if let value = shows[index].formattedDateTime {
                    cell.showDetailText.text = value
                    cell.showIndex.text = "Show \(index+1)"
                    cell.selectionStyle = .None
                }
            }
            return cell
        } else if section == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier("venue_cell", forIndexPath: indexPath) as! CompetitionVenueTableViewCell
            if let name = self.event?.associatedVenue?.venueName {
                cell.venueName.text = name
                cell.selectionStyle = .None
            }
            return cell
        } else if section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("description_cell", forIndexPath: indexPath) as! CompetitionDescriptionTableViewCell
            cell.descriptionView.text = self.event?.description!
            cell.descriptionView.editable = false
            cell.selectionStyle = .None
            return cell
        }
        return UITableViewCell()
    }
    
    @IBAction func enterCompetitionAction(sender: UIBarButtonItem) {
        // perform check here
        // checking memebership id
        if self.masterEvent?.canUserEnterCompetition() == true {
            if let competition = self.event?.competition {
                if competition.canEnterCompetition && competition.status == "running" {
                    self.performSegueWithIdentifier("enter_competition", sender: sender)
                } else if competition.status == "closed" {
                    alertUser(competition.humanReadableDateTo, time: competition.humanReadableTimeTo, competionPassed: true)
                } else if competition.status == "not_started" {
                    alertUser(competition.humanReadableDateFrom, time: competition.humanReadableTimeFrom, competionPassed: false)
                }
            }
        } else {
            let alertController = UIAlertController(title: "Competition Information", message: "Please upgrade to Gold Membership to enter the competition", preferredStyle: .ActionSheet)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func alertUser(date: String, time: String, competionPassed: Bool) {
        let messageString = competionPassed == true ? "Competition finished on \(date) \(time)" : "Competition will start on \(date) \(time)"
        let alertController = UIAlertController(title: "Competition Information", message: messageString, preferredStyle: .ActionSheet)
        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "enter_competition" {
            let destinationController = segue.destinationViewController as! EnterCompetitionTableViewController
            destinationController.eventId = self.event?.id
            destinationController.competition = self.event?.competition
        }
    }
    
    @IBAction func unwindToCompetitionDetail(segue: UIStoryboardSegue) {
        
    }
}
