//
//  ReservationMasterTableViewCell.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 12/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class ReservationMasterTableViewCell: UITableViewCell {
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var Ticket_no: UILabel!
    @IBOutlet weak var venue_Name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
