//
//  NavigationViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 25/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import MapKit

class NavigationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager?
    var venue: Venue?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(venue?.addressForGeocoder)
        mapView.mapType = .Standard
        mapView.delegate = self
        mapView.frame = view.frame
        view.addSubview(mapView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mapView = MKMapView()
    }
    
    func provideDirectionsToUser() {
        print("provideDirectionsToUser called")
        if let venue = self.venue {
            CLGeocoder().geocodeAddressString(venue.addressForGeocoder) { (placemarksList, error) in
                guard let placemarks = placemarksList else {
                    return
                }
                let request = MKDirectionsRequest()
                request.source = MKMapItem.mapItemForCurrentLocation()
                
                let placemark = placemarks.first
                if let destinationCoordinates = placemark?.location?.coordinate {
                    let destination = MKPlacemark(coordinate: destinationCoordinates, addressDictionary: nil)
                    request.destination = MKMapItem(placemark: destination)
                    request.transportType = .Automobile
                    
                    MKDirections.init(request: request).calculateDirectionsWithCompletionHandler({ (response, error) in
                        guard let response = response else {
                            return
                        }
                        
                        let launchOptions = [
                            MKLaunchOptionsDirectionsModeKey:
                            MKLaunchOptionsDirectionsModeDriving]
                        MKMapItem.openMapsWithItems([response.source, response.destination], launchOptions: launchOptions)
                    })
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        print("did Change Authorization Status")
        
        switch CLLocationManager.authorizationStatus() {
        case .Denied:
            print("Denied")
        case .NotDetermined:
            print("Not determined")
        case .Restricted:
            print("Restricted")
        default:
            print("Authorized")
            provideDirectionsToUser()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if CLLocationManager.locationServicesEnabled() {
            print("Location services enabled")
            switch CLLocationManager.authorizationStatus() {
            case .NotDetermined:
                locationManager = CLLocationManager()
                if let manager = self.locationManager{
                    manager.delegate = self
                    manager.requestWhenInUseAuthorization()
                }
            default:
                provideDirectionsToUser()
            }
        } else {
            print("Location services not enabled")
        }
    }
    
}
