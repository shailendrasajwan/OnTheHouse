//
//  DetailTableViewCell.swift
//  OnTheHouse
//
//  Created by Reza Adhitya Boer on 23/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {


    @IBOutlet weak var memberShipLevelLabel: UILabel!
    
    @IBOutlet weak var timeFrom: UILabel!
    
    @IBOutlet weak var dateFrom: UILabel!
    
    @IBOutlet weak var dateTo: UILabel!
    
    
    @IBOutlet weak var timeTo: UILabel!
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var bookButton: UIButton!
    
    @IBOutlet weak var ticketsAvailablelabel: UILabel!
    
    @IBOutlet weak var venueButton: UIButton!
    
    @IBOutlet weak var bookTicketLabel: UILabel!
    @IBOutlet weak var ticketsLeftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
