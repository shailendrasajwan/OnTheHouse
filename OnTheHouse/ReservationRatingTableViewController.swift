//
//  ReservationRatingTableViewController.swift
//  OnTheHouse
//
//  Created by Shailendra Singh Sajwan on 26/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Cosmos

class ReservationRatingTableViewController: UITableViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    
    var reservationObject: MemberReservation?
    var userRatingValue: Double = 0.0
    var reservationRatingRequest: [String:String] = [:]
    var eventId: Int = 0
    var completionStatus: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTextView.delegate = self
        print(reservationObject?.eventName)
        
        if let id: Int =   reservationObject!.eventId!{
            self.eventId = id
            print(self.eventId)
        }
        
        
        let userID = String(NSUserDefaults.standardUserDefaults().integerForKey("id"))
        OTHService.sharedInstance.postDataToOTH("member/event-rating", parameters: ["member_id": userID,"event_id": self.eventId]) { (dictionary) in
            if let eventDictionary = dictionary["rating"] as? [String: AnyObject] {
                
                let rating = eventDictionary["rating"]?.doubleValue ?? 0
                self.cosmosView.rating = rating
                
                if let comment = eventDictionary["comments"] as? String {
                    print(comment)
                    self.reviewTextView.text = comment
                    self.reviewTextView.editable = false
                }
            }
        }
      
        
        let hasRated = self.reservationObject?.hasRated
        if hasRated! == false {
            self.cosmosView.settings.updateOnTouch = true
        }
        else{
            self.cosmosView.settings.updateOnTouch = false
            doneButton.enabled = false
            
            let alertController = UIAlertController(title: "Show Rating", message: "You have already rated the show", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        cosmosView.didTouchCosmos = { rating in
            self.userRatingValue = rating
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func doneAction(sender: UIBarButtonItem) {
        
        var eventId = 0
        if let id: Int =   reservationObject!.eventId!{
            eventId = id
        }
        
        reservationRatingRequest["event_id"] = String(eventId)
        reservationRatingRequest["member_id"] = String(NSUserDefaults.standardUserDefaults().integerForKey("id"))
        reservationRatingRequest["rating"] =  String(userRatingValue)
        reservationRatingRequest["comments"] =  reviewTextView.text
        print(reservationRatingRequest)
        ReservationHelper.sendResevationRatingToOTH(reservationRatingRequest){ (result) in
            print(result)
            self.completionStatus = result
            self.performSegueWithIdentifier("backToReservationMaster", sender: sender)
        }
    }
    
    @IBAction func backAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ReservationRatingTableViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(textView: UITextView) {
        tableView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        reviewTextView.text = ""
    }
}