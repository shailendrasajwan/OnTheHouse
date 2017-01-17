//
//  SelectQuantityViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 3/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Eureka

class SelectQuantityViewController: FormViewController {
    
    var show: Show?
    var quantityPurchased: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("show id")
        print(show?.showID)
        print("quantity purchased \(self.quantityPurchased)")
        form +++ Section("Select Quanity")
            
            <<< PickerRow<String>("quantity") { (row : PickerRow<String>) -> Void in
                row.title = "Pick your option"
                if let show = self.show {
                    if show.memberCanChoose == true {
                        var quantityUserCanBuy = 0
                        if let quantityPurchased = self.quantityPurchased {
                            if let maxLimit = show.maximumTicketsPerMember {
                                quantityUserCanBuy = maxLimit - quantityPurchased
                                print("quantity user can buy \(quantityUserCanBuy)")
                            }
                            if quantityUserCanBuy > 1 {
                                for i in 1...quantityUserCanBuy {
                                    row.options.append(String(i))
                                }
                            } else {
                                row.options.append(String(1))
                            }
                        } else if let quantities = show.allowedQuantity {
                            row.options = quantities.map({ String($0)})
                        }
                    } else {
                        if let maximumTickets = show.maximumTicketsPerMember {
                            row.options.append(String(maximumTickets))
                        }
                    }
                    row.value = row.options.first
                } 
            }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let valuesDictionary = form.values()
        if segue.identifier == "bookShowSegue" {
            let destinationController = segue.destinationViewController as! ShowBookingDetailViewController
            destinationController.show = self.show
            destinationController.quantity = valuesDictionary["quantity"] as? String
        }
    }
    
    
    @IBAction func navigateToBookingConfirmation(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("bookShowSegue", sender: sender)
    }
}
