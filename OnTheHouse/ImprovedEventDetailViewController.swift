//
//  ImprovedEventDetailViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 10/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Cosmos
class ImprovedEventDetailViewController: UIViewController {
    
    @IBOutlet var ratingBar: CosmosView!
    @IBOutlet weak var eventimg: UIImageView!
    var eventId: Int = 0
    var event: EventImproved?
    @IBOutlet weak var bookShowButton: UIBarButtonItem!
    @IBOutlet weak var showName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var priceHeading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionText.editable = false
        eventimg.layer.cornerRadius = 10
        eventimg.clipsToBounds = true
        eventimg.layer.borderColor = UIColor.blackColor().CGColor
        eventimg.layer.borderWidth = 4

        print(eventId)
        bookShowButton.enabled = false
        guard let userID = NSUserDefaults.standardUserDefaults().valueForKey("id") as? Int else {
            return
        }
        
        OTHService.sharedInstance.postDataToOTH("event/\(eventId)", parameters: ["member_id": userID]) { (dictionary) in
            if let eventDictionary = dictionary["event"] as? [String: AnyObject] {
                self.event = EventImproved(data: eventDictionary)
                self.configureCompetition()
                self.populateDataFields()
            }
        }
    }
    
    func configureCompetition() {
        if self.event?.isCompetition == true {
            self.bookShowButton.tag = 1
            if self.event?.competition?.canEnterCompetition == true {
                self.bookShowButton.title = "Enter Competition"
                self.bookShowButton.enabled = true
            } else {
                self.bookShowButton.title = "Competition Coming Up"
                self.bookShowButton.enabled = false
            }
        } else {
            self.bookShowButton.tag = 2
            self.bookShowButton.enabled = true
        }
    }
    
    
    func populateDataFields() {
        
        if let eventName = event?.name {
            print(eventName)
            showName.text = eventName
        }
        
        if let  eventImage = event?.thumbNailImage {
            eventimg.image = eventImage
        }
        
        print("Price: \(event?.ourPriceString)")
        if let eventPrice = event?.ourPriceString {
            price.text = eventPrice
        }
        
        if let description = event?.description {
            descriptionText.text = description
        }
        print("Heading \(event?.getPrettyPriceHeading)")
        priceHeading.text = event?.getPrettyPriceHeading
        if let rating = event?.rating {
            ratingBar.rating = rating
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            switch(identifier) {
            case "detailedShow":
                let destinationViewController = segue.destinationViewController as? DetailTableViewController
                destinationViewController?.shows = self.event?.eventShowList
                destinationViewController?.venue = self.event?.showDataCollection!.first?.venue
                break
            case "competitionSegue":
                let destinationViewController = segue.destinationViewController as? CompetitionViewController
                destinationViewController?.competition = self.event?.competition
                destinationViewController?.eventId = self.event?.id
                break
            default:
                break
            }
        }
    }
    
    @IBAction func bookingButtonTapped(sender: UIBarButtonItem) {
        switch(sender.tag) {
        case 1:
            self.performSegueWithIdentifier("competitionSegue", sender: sender)
            break
        case 2:
            self.performSegueWithIdentifier("detailedShow", sender: sender)
            break
        default:
            break
        }
    }
    
    @IBAction func backFromCompetition(segue: UIStoryboardSegue) {
        
    }
    
    
    @IBAction func broadCastAction(sender: UIBarButtonItem) {
        
        guard let imageToShare = self.event?.thumbNailImage, let title = self.event?.name else {
            return
        }
        let objectsToShare = [title, imageToShare] as AnyObject
        let activityVC = UIActivityViewController(activityItems: objectsToShare as! [AnyObject], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = view
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
}

