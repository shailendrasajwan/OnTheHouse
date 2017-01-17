//
//  ReservationMasterTableViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 12/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import MapKit

class ReservationMasterTableViewController: UITableViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var currentReservationList: [MemberReservation]?
    var upComingReservationList: [MemberReservation]?
    var pastReservationList: [MemberReservation]?
    var venueAnnotation: MKPointAnnotation?
    var venueObject: Venue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 0
        //makeInitialCall()
        getPastReservations()
    }
    
    private func makeInitialCall() {
        OTHService.sharedInstance.postDataToOTH("member/reservations", parameters: ["member_id": NSUserDefaults.standardUserDefaults().integerForKey("id")]) { (dictionary) in
            if let current = DataFormatter.getCurrentReservationList(dictionary) {
                self.currentReservationList = current
                self.upComingReservationList = current
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        if segue.identifier == "backToReservationMaster" {
            if let sourceViewController = segue.sourceViewController as? ReservationRatingTableViewController {
                print("Rewind")
                print(sourceViewController.completionStatus)
                let alertController = UIAlertController(title: "Show Rating", message: "You have already rated the show", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(alertAction)
                presentViewController(alertController, animated: true, completion: nil)
                
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.currentReservationList?.count ?? 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reservationCell") as! ReservationMasterTableViewCell
        if let reservationObject = self.currentReservationList?[indexPath.row] {
            
            cell.eventTitle.text = reservationObject.eventName ?? "N/A"
            cell.dateTitle.text = reservationObject.eventDate ?? "N/A"
            if let quantity = reservationObject.ticketQuantity {
                cell.Ticket_no.text = "Quantity - \(quantity)"
            }
            if let venue = reservationObject.venueName {
                cell.venue_Name.text = "Venue - \(venue)"
            }
            cell.selectionStyle = .None
        }
        return cell
    }
    
    
    @IBAction func segmentIndexChanged(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        /*
        switch sender.selectedSegmentIndex {
        case 1:
            if let upComing = self.upComingReservationList {
                self.currentReservationList = upComing
                self.tableView.reloadData()
            } else {
                self.makeInitialCall()
            }
            break
        case 0:
            if let past = self.pastReservationList {
                self.currentReservationList = past
                self.tableView.reloadData()
            } else {
                getPastReservations()
            }
            break
        default:
            break
        } */
        
        switch sender.selectedSegmentIndex {
        case 1:
            self.makeInitialCall()
            break
        case 0:
            getPastReservations()
            break
        default:
            break
        }
    }
    
    private func getPastReservations() {
        OTHService.sharedInstance.postDataToOTH("member/reservations/past", parameters: ["member_id": NSUserDefaults.standardUserDefaults().integerForKey("id")]) { (dictionary) in
            let reservationList = DataFormatter.getCurrentReservationList(dictionary)
            self.pastReservationList = reservationList
            self.currentReservationList = reservationList
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // Social Sharing Button
        
        if segmentedControl.selectedSegmentIndex == 1 {
            let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Share",
                                                   handler: { (action, indexPath) -> Void in
                                                    let shareActionText = "Thanks for your help"
                                                    
                                                    if let imageToShare = UIImage(named: "meal1") {
                                                        
                                                        let activityController = UIActivityViewController(activityItems:
                                                            
                                                            [shareActionText, imageToShare], applicationActivities: nil)
                                                        
                                                        self.presentViewController(activityController, animated: true,
                                                            
                                                            completion: nil)
                                                        
                                                        
                                                    }
                                                    
            })
            
            let cancelShowAction = UITableViewRowAction(style: .Default, title: "Cancel") { (action, indexPath) in
                if let reservationList = self.currentReservationList {
                    if let reservationID = reservationList[indexPath.row].reservationId {
                        self.cancelButtonPressed(reservationID)
                    }
                }
            }
            
            shareAction.backgroundColor = UIColor(red: 135.0/255.0, green: 211.0/255.0, blue: 124.0/255.0, alpha: 1.0)
            cancelShowAction.backgroundColor = UIColor.redColor()
            return [shareAction, cancelShowAction]
        } else if segmentedControl.selectedSegmentIndex == 0 {
            let ratingAction = UITableViewRowAction(style: .Default, title: "Rate Show", handler: { (action, indexPath) in
                print("Go to rating page")
                tableView.tag = indexPath.row
                self.performSegueWithIdentifier("rating", sender: tableView)
            })
            
            ratingAction.backgroundColor = UIColor.blueColor()
            return [ratingAction]
        }
        return nil
    }
    
    func cancelButtonPressed(reservationId: Int) {
        print("cancel pressed")
        cancelReservation("reservation/cancel", params: ["reservation_id": "\(reservationId)",
            "member_id": "\(NSUserDefaults.standardUserDefaults().integerForKey("id"))"])
    }
    
    
    func cancelReservation(subUrl: String, params: [String: AnyObject]) {
        OTHService.sharedInstance.postDataToOTH(subUrl, parameters: params) { (dictionary) in
            if !APIStatus.isSuccessfulResponse(dictionary) {
                if let list = APIStatus.retrieveErrorMessage(dictionary) {
                    if let alert = APIStatus.showAlertMessageToUser(list) {
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            } else {
                self.showCancelConfirmationMessage()
            }
        }
    }
    
    func showCancelConfirmationMessage() {
        let alertController = UIAlertController(title: "Cancellation Complete", message: "Your reservation has been cancelled", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(action)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        print("willBeginEditingRowAtIndexPath")
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        print(" didEndEditingRowAtIndexPath")
    }
    
    //
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentReservationObject = self.currentReservationList![(indexPath.row)]
        if let venueID = currentReservationObject.venueID {
            makeNetworkCall("venue/\(venueID)", completionHandler: { (annotation) in
                self.venueAnnotation = annotation
                self.performSegueWithIdentifier("userReservationDetail", sender: nil)
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let tableview = sender as? UITableView {
            if segue.identifier == "rating" {
                print("Index ******")
                print(tableview.tag)
                let currentReservationObject = self.currentReservationList![tableview.tag]
                let destinationController = segue.destinationViewController as? UINavigationController
                let ratingController = destinationController?.viewControllers.first as! ReservationRatingTableViewController
                ratingController.reservationObject = currentReservationObject
            }
        } else if segue.identifier == "userReservationDetail" {
            if let selectedIndex = self.tableView.indexPathForSelectedRow {
                let currentReservationObject = currentReservationList![(selectedIndex.row)]
                let destinationController = segue.destinationViewController as? ReservationDetailTableViewController
                destinationController?.reservationObject = currentReservationObject
                destinationController?.venueAnnotation = self.venueAnnotation
                destinationController?.venueObject = self.venueObject
            }
        }
    }
    
    func makeNetworkCall(apiEndPoint: String, completionHandler: MKPointAnnotation -> ()) {
        OTHService.sharedInstance.getDataFromOTH(apiEndPoint) { (dictionary) in
            self.getVenueObject(dictionary, completion: { (venue) in
                self.getPlaceMark(venue, completion: { (placeMark) in
                    completionHandler(self.getVenueAnnotationObject(venue, placemark: placeMark))
                })
            })
        }
    }
    
    func getVenueObject(jsonDictionary: [String: AnyObject], completion: Venue -> ()){
        if let venueDictionary = jsonDictionary["venue"] as? [String: AnyObject] {
            let venue = Venue(data: venueDictionary)
            self.venueObject = venue
            completion(venue)
        }
    }
    
    
    func getPlaceMark(venue: Venue,completion: CLPlacemark -> ()) {
        CLGeocoder().geocodeAddressString(venue.addressForGeocoder) { (placemarks, error) in
            if error != nil {
                return
            }
            
            if let palcemarks = placemarks {
                completion(palcemarks[0])
            }
        }
    }
    
    func getVenueAnnotationObject(venueObject: Venue, placemark: CLPlacemark) -> MKPointAnnotation {
        let venueAnnotation = MKPointAnnotation()
        venueAnnotation.title = venueObject.venueName
        venueAnnotation.subtitle = venueObject.addressForAnnotationView
        if let venueLocation = placemark.location {
            venueAnnotation.coordinate = venueLocation.coordinate
        }
        return venueAnnotation
    }
    
    


}
