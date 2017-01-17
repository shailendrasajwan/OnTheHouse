//
//  ReservationDetailTableViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 25/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import MapKit

class ReservationDetailTableViewController: UITableViewController, MKMapViewDelegate {
    
    var reservationObject: MemberReservation?
    let sectionHeaders = ["Name", "Date & Time", "Address", "Map"]
    var venueAnnotation: MKPointAnnotation?
    var venueObject: Venue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Annotation \(venueAnnotation?.coordinate)")
        tableView.estimatedRowHeight = 44.0
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "mapViewCell", bundle: nil), forCellReuseIdentifier: "mapCell")
        tableView.registerNib(UINib(nibName: "ReservationTitleCell", bundle: nil), forCellReuseIdentifier: "name")
    }
    
    @IBAction func navigateAction(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("navigationSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segueing ...")
        if segue.identifier == "navigationSegue" {
            let destinationViewController = segue.destinationViewController as! NavigationViewController
            destinationViewController.venue = self.venueObject
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sectionHeaders.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 3 {
            print("map view")
            let cell = prepareMapView(self.venueAnnotation!, tableView: tableView, cellForRowAtIndexPath: indexPath)
            cell.selectionStyle = .None
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("name", forIndexPath: indexPath) as! nameTableViewCell
            cell.selectionStyle = .None
            if section == 0 {
                cell.nameLabel.text = self.reservationObject?.eventName
                return cell
            }  else if section == 1 {
                cell.nameLabel.text = self.reservationObject?.eventDate
                return cell
            }  else if section == 2 {
                if let address = self.venueObject?.addressForGeocoder {
                    cell.nameLabel.text = address
                } else {
                    cell.nameLabel.text = self.reservationObject?.venueName
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaders[section]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Section: \(indexPath.section)")
        print("index: \(indexPath.row)")
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    // network call to get venue dictionary , return type map view cell
    // get venue object
    // get placemark
    // get annotation
    // get cell
    
    func prepareMapView(annotation: MKPointAnnotation, tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ReservationMapViewTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mapCell", forIndexPath: indexPath) as! ReservationMapViewTableViewCell
        cell.mapView.showsCompass = true
        cell.mapView.showsScale = true
        cell.mapView.showsTraffic = true
        cell.mapView.delegate = self
        cell.mapView.showAnnotations([annotation], animated: true)
        cell.mapView.selectAnnotation(annotation, animated: true)
        return cell
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let selectedAnnotations = mapView.selectedAnnotations
        
        print("didSelectAnnotationView")
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
        
        if control == view.rightCalloutAccessoryView {
            print("button clicked")
            self.performSegueWithIdentifier("navigationSegue", sender: nil)
        }
    }
    
    func touchedDisclosure() {
        print("inside touch action")
        self.performSegueWithIdentifier("navigationSegue", sender: nil)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("viewForAnnotation")
        let identifier = "MyPin"
        // Reuse the annotation if possible
        var annotationView: MKPinAnnotationView? =
            mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as?
        MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation,
                                                 reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        /*
         let leftIconView = UIImageView(frame: CGRectMake(0, 0, 36, 36))
         leftIconView.image = UIImage(named: "SUV-36")
         annotationView?.leftCalloutAccessoryView = leftIconView*/
        
        let disclosureButton =  UIButton(type: .DetailDisclosure)
        /*
         disclosureButton.addTarget(self, action:  #selector(ReservationDetailTableViewController.touchedDisclosure), forControlEvents: .AllTouchEvents) */
        annotationView?.rightCalloutAccessoryView = disclosureButton
        return annotationView
    }
}
