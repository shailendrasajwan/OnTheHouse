//
//  ReservationHelper.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 16/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

/*
 "status":"success",
	"paypal":"1",
	"reservation_id":"18418",
	"paypal_email":"irenameister@gmail.com",
	"item_name":"Test Event",
	"item_sku":"3897-11357-18418-ma",
	"item_price":"10.00",
	"item_quantity":"2",
	"shipping_price":"5.00"
 */

import UIKit
class ReservationRequest {
    
    var paypal: Bool?
    let reservationId: Int?
    var itemQuantity: Int?
    var itemPrice: Double?
    let shippingPrice: Double?
    let itemName: String?
    let affiliateUrl: String?
    
    init(data: [String: AnyObject]) {
        
        print("data from the server")
        print(data)
        print("data ******")
        
        if let itemName = data["item_name"] as? String {
            self.itemName = itemName
        } else {
            self.itemName = nil
        }
        
        if let reservationId = data["reservation_id"] as? Int {
            self.reservationId = reservationId
        } else {
            print("cant cast into int")
            self.reservationId = nil
        }
        
        if let quantity = data["item_quantity"] as? Int {
            self.itemQuantity = quantity
        } else {
            print("cant cast into int")
            self.itemQuantity = nil
        }
       
        if let itemPrice = data["item_price"] as? String {
            self.itemPrice = Double(itemPrice)
        } else if let itemPrice = data["item_price"] as? Double {
            self.itemPrice = itemPrice
        } else {
            self.itemPrice = nil
        }
        
        if let shippingPrice = data["shipping_price"] as? String {
            self.shippingPrice = Double(shippingPrice)
        } else if let shippingPrice = data["shipping_price"] as? Double {
            self.shippingPrice = shippingPrice
        } else {
            self.shippingPrice = nil
        }
        
        if let paypal = data["paypal"] as? Int {
            self.paypal = paypal == 1 ? true : false
        } else {
            self.paypal = nil
        }
        
        if let url = data["affiliate_url"] as? String {
            self.affiliateUrl = url
        } else {
            self.affiliateUrl = nil
        }
    }
}


import Foundation

class ReservationHelper {
    static func getNumberOfTicketsBought(showID: Int, completionHandler: Int -> ()) {
        var ticketsBought = 0
        getReservationArrayList { (reservationList) in
            for reservation in reservationList {
                if let reservationShowID = reservation.showId {
                    if reservationShowID == showID {
                        print("inside")
                        if let ticketsPurchased = reservation.ticketQuantity {
                            ticketsBought += ticketsPurchased
                        }
                    }
                }
            }
            completionHandler(ticketsBought)
        }
    }
    
    static func getReservationArrayList(completionHandler: [Reservation] -> ()) {
        let memberID = NSUserDefaults.standardUserDefaults().integerForKey("id")
        var reservationArray: [Reservation] = []
        OTHService.sharedInstance.postDataToOTH("member/reservations-raw", parameters: ["member_id": String(memberID)]) { (dictionary) in
            print(dictionary)
            if let reservations = dictionary["reservations"] as? [[String: AnyObject]] {
                for reservation in reservations {
                    reservationArray.append(Reservation(data: reservation))
                }
                completionHandler(reservationArray)
            }
        }
    }
    
    static func sendReservationRequest(params: [String: AnyObject], completion: (ReservationRequest?, UIAlertController?) -> ()) {
        OTHService.sharedInstance.postDataToOTH("reserve", parameters: params, completionHandler: { (dictionary) in
            
            print("*********")
            print(dictionary)
            print("*********")
            
            if !APIStatus.isSuccessfulResponse(dictionary) {
                if let errorMessages = APIStatus.retrieveErrorMessage(dictionary) {
                    if let alertController = APIStatus.showAlertMessageToUser(errorMessages) {
                        completion(nil, alertController)
                    }
                }
            } else {
                completion(ReservationRequest(data: dictionary), nil)
            }
        })
    }
    
    static func sendPaymentConfirmationToOTH(params: [String: AnyObject], completion: (Bool) -> ()) {
        print("starting call")
        
        OTHService.sharedInstance.postDataToOTH("reserve/complete", parameters: params, completionHandler: { (dictionary) in
            print(dictionary)
            
            guard let status = dictionary["status"] as? String else {
                return
            }
            completion(status == "success" ? true : false)
        })
    }
    
    
    static func sendResevationRatingToOTH(params: [String: AnyObject], completion: (Bool) -> ()) {
        print("starting call")
        
        OTHService.sharedInstance.postDataToOTH("event/rate/", parameters: params, completionHandler: { (dictionary) in
            print(dictionary)
            
            guard let status = dictionary["status"] as? String else {
                return
            }
            completion(status == "success" ? true : false)
        })
    }
    
    
}















