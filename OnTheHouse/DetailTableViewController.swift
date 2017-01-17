//
//  DetailTableViewController.swift
//  OnTheHouse
//
//  Created by Reza Adhitya Boer on 23/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit


class DetailTableViewController: UITableViewController{

    var shows: [Show]?
    var venue: Venue?
    var venueList: [Venue]?
    var quantityBought = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.venueList = []
    }
    
    // TODO: - Checks that need to be implemented 1.Date Hide 2.Time Hide 3.Quantity of tickets member can purchase 4. Affiliate Link
    
    // Hide details like price, quantity book button, book button label when the ticket is sold out or when the date is in the past
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
                                                               forIndexPath: indexPath) as! DetailTableViewCell
        let show = shows![indexPath.row]
        cell.priceLabel.text = "$ " + String(show.price!)
        cell.venueButton.tag = show.venueID!
        if show.soldOut == true {
            cell.bookButton.enabled = false
            cell.bookTicketLabel.text = "Sold Out"
            cell.ticketsAvailablelabel.text = "No"
            cell.venueButton.enabled = false
        } else {
            cell.bookButton.tag = indexPath.row
            cell.ticketsAvailablelabel.text = String((show.totalTickets! - show.reservedTickets!))
        }
        print("venue id: \(cell.venueButton.tag)")
        cell.memberShipLevelLabel.text = show.memberShipExplainationText
        if let venueID = show.venueID {
            OTHService.sharedInstance.getDataFromOTH("venue/\(venueID)") { (dictionary) in
                DataFormatter.getVenueObject(dictionary, completion: { (venue) in
                    cell.venueNameLabel.text = venue.venueName
                    self.venueList?.append(venue)
                })
            }
        }
        cell.dateFrom.text = show.humanReadableDateStringFrom
        cell.dateTo.text = show.humanReadableDateStringTo
        cell.timeFrom.text = show.humanReadableTimeStringFrom
        cell.timeTo.text = show.humanReadableTimeStringTo
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int {
        return (shows?.count)!
    }
    
    @IBAction func bookShowAction(sender: UIButton) {
        let currentShow = self.shows![sender.tag]
    
        if currentShow.isBookable() {
            if let showId = currentShow.showID {
                ReservationHelper.getNumberOfTicketsBought(showId, completionHandler: { (quantityBought) in
                    print("******* \(quantityBought)")
                    if quantityBought > 0 {
                        self.quantityBought = quantityBought
                    }
                    
                    if quantityBought < currentShow.maximumTicketsPerMember {
                        self.performSegueWithIdentifier("bookShow", sender: sender)
                    } else {
                        let alertController = UIAlertController(title: "Limit Reached", message: "Sorry, You have exhausted your quota", preferredStyle: .Alert)
                        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(alertAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                })
            }
            
        } else {
            let alertController = UIAlertController(title: "Upgrade Membership", message: "Please upgrade your membership to Gold before booking this show", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let sender = sender as? UIButton {
            switch(segue.identifier!) {
            case "bookShow":
                let destinationController = segue.destinationViewController as? SelectQuantityViewController
                destinationController?.show = self.shows![sender.tag]
                destinationController?.quantityPurchased = self.quantityBought
                break
            case "revealVenue":
                let destinationController = segue.destinationViewController as? RevealShowVenueMapViewController
                destinationController?.venueID = sender.tag
                break
            default:
                break
            }
        }
    }
}

