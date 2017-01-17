//
//  ReservationMapViewTableViewCell.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 25/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import MapKit

class ReservationMapViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
