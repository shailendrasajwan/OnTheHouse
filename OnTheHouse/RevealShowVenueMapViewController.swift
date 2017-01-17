//
//  RevealShowVenueMapViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 10/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import MapKit

class RevealShowVenueMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var venueID: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true

        if let venueId = self.venueID {
            OTHService.sharedInstance.getDataFromOTH("venue/\(venueId)", completionHandler: { (dictionary) in
                DataFormatter.getVenueObject(dictionary, completion: { (venueObject) in
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(venueObject.addressForGeocoder) { (placeMarks, error) in
                        if error != nil {
                            return
                        }
                        
                        if let locationPlaceMarks = placeMarks {
                            let individualPlaceMark = locationPlaceMarks.first
                            
                            let venueAnnotation = MKPointAnnotation()
                            venueAnnotation.title = venueObject.venueName
                            venueAnnotation.subtitle = venueObject.addressForAnnotationView
                            
                            if let venueLocation = individualPlaceMark?.location {
                                venueAnnotation.coordinate = venueLocation.coordinate
                            }
                            
                            self.mapView.showAnnotations([venueAnnotation], animated: true)
                            self.mapView.selectAnnotation(venueAnnotation, animated: true)
                        }
                    }
                })
            })
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
