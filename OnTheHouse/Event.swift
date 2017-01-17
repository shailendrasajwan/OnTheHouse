//
//  Event.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 16/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import UIKit

let dateFormatter: NSDateFormatter = NSDateFormatter()

func timeStringFromUnixTime(unixTime: Double) -> String {
    let date = NSDate(timeIntervalSince1970: unixTime)
    dateFormatter.dateFormat = "hh:mm a"
    return dateFormatter.stringFromDate(date)
}

func dayStringFromTime(unixTime: Double) -> String {
    let date = NSDate(timeIntervalSince1970: unixTime)
    dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.stringFromDate(date)
}

func dateStringFromTime(unixTime: Double) -> String {
    let date = NSDate(timeIntervalSince1970: unixTime)
    dateFormatter.dateStyle = .ShortStyle
    return dateFormatter.stringFromDate(date)
}

extension NSDate {
    
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        return self.compare(dateToCompare) == NSComparisonResult.OrderedSame
    }
}

class Reservation {
    
    let showId: Int?
    let ticketQuantity: Int?
    
    init(data: [String: AnyObject]) {
        if let showID = data["show_id"] as? String {
            self.showId = Int(showID)
            print(self.showId)
        } else {
            self.showId = 0
        }
        
        if let ticketQty = data["tickets"] as? String {
            self.ticketQuantity = Int(ticketQty)
            print(self.ticketQuantity)
        } else {
            self.ticketQuantity = 0
        }
    }
    
}

class Event {
    
    let id: Int?
    let type: String?
    let name: String?
    let rating: Int?
    let imageUrl: NSURL?
    let description: String?
    let priceFrom: Double?
    let priceTo: Double?
    let fullPriceString: String?
    let ourPriceString: String?
    let ourPriceHeading: String?
    let membershipLevels: String?
    let soldOut: Bool?
    let comingSoon: Bool?
    let isCompetition: Bool?
    var competition: Competition?
    let showData: ShowData?
    
    var thumbNailImage: UIImage? {
        get {
            let data = NSData(contentsOfURL: self.imageUrl!)
            return UIImage(data: data!)
        }
    }
    
    var goldLogoVisibility: Bool {
        get {
            if let memberShip = self.membershipLevels {
                return memberShip.lowercaseString.containsString("Gold".lowercaseString) ? false : true
            }
            return true
        }
    }
    
    var bronzeLogoVisibility: Bool {
        get {
            if let memberShip = self.membershipLevels {
                return memberShip.lowercaseString.containsString("Bronze".lowercaseString) ? false : true
            }
            return true
        }
    }
    
    var eventPirceHeadingAndPrice: String {
        return getPrettyPriceHeading + " - " + self.ourPriceString!
    }
    
    var priceRange: String {
        return "Full Price" + " - " + self.fullPriceString!
    }
    
    var getPrettyPriceHeading: String {
        get {
            var finalString = ""
            if let priceHeading = self.ourPriceHeading {
                switch priceHeading.lowercaseString {
                case "On The House DISCOUNTED TICKET PRICE".lowercaseString:
                    finalString = "Discounted Price"
                    break
                case "On The House Admin Fee".lowercaseString:
                    finalString = "Admin Fee"
                    break
                default:
                    break
                }
            }
            return finalString
        }
    }
    
    var getPrettyFinalPriceString: String {
        get {
            var finalPrice = ""
            if fullPriceString! == "" || fullPriceString! == "$0"  {
                finalPrice = "FREE"
            } else {
                finalPrice = fullPriceString!
            }
            return finalPrice
        }
    }
    
    var memberShipLevelID: Int? {
        if let memberShipString = self.membershipLevels {
            print(memberShipString)
            let finalMemberShipString = memberShipString.lowercaseString
            
            if (finalMemberShipString.containsString("gold") && !finalMemberShipString.containsString("bronze")) {
                print("first")
                return 9
            } else if (finalMemberShipString.containsString("gold") && finalMemberShipString.containsString("bronze")) {
                print("second")
                return 3
            }
            return nil
        }
        return nil
    }
    
    func canUserEnterCompetition() -> Bool {
        let userMemberLevelID = NSUserDefaults.standardUserDefaults().integerForKey("membership_level")
        var value = false
        switch(self.memberShipLevelID!, userMemberLevelID) {
        case(MemberShip.Bronze.levelID, MemberShip.Bronze.levelID):
            value = true
            break
        case(MemberShip.Bronze.levelID, MemberShip.Gold.levelID):
            value = true
            break
        case(MemberShip.Gold.levelID, MemberShip.Bronze.levelID):
            value = false
            break
        case(MemberShip.Gold.levelID, MemberShip.Gold.levelID):
            value = true
            break
        default:
            break
        }
        return value
    }
    
    init(data: [String: AnyObject]) {
        
        if let id = data["id"] as? String {
            self.id = Int(id)
        }  else {
            self.id = 0
        }
        
        if let type = data["type"] as? String {
            self.type = type
        }  else {
            self.type = ""
        }
        
        if let name = data["name"] as? String {
            self.name = name
        }  else {
            self.name = ""
        }
        
        if let rating = data["rating"] as? Int {
            self.rating = rating
        }  else {
            self.rating = 0
        }
        
        if let description = data["description"] as? String {
            self.description = description
            
        }  else {
            self.description = ""
        }
        
        if let imageUrl = data["image_url"] as? String {
            self.imageUrl = NSURL(string: imageUrl)!
        }  else {
            self.imageUrl = NSURL()
        }
        
        if let priceFrom = data["price_from"] as? Double {
            self.priceFrom = priceFrom
        }  else {
            self.priceFrom = 0.0
        }
        
        if let priceTo = data["price_to"] as? Double {
            self.priceTo = priceTo
        }  else {
            self.priceTo = 0.0
        }
        
        if let fullPriceString = data["full_price_string"] as? String {
            self.fullPriceString = fullPriceString
        }  else {
            self.fullPriceString = ""
        }
        
        if let ourPriceHeading = data["our_price_heading"] as? String {
            self.ourPriceHeading = ourPriceHeading
        }  else {
            self.ourPriceHeading = ""
        }
        
        if let ourPriceString = data["our_price_string"] as? String {
            self.ourPriceString = ourPriceString
        }  else {
            self.ourPriceString = ""
        }
        
        if let membershipLevels = data["membership_levels"] as? String {
            self.membershipLevels = membershipLevels
        }  else {
            self.membershipLevels = ""
        }
        
        if let soldOut = data["sold_out"] as? Int {
            self.soldOut = soldOut == 1 ? true : false
        }  else {
            self.soldOut = false
        }
        
        if let comingSoon = data["coming_soon"] as? Int {
            self.comingSoon = comingSoon == 1 ? true : false
        }  else {
            self.comingSoon = false
        }
        
        if let isCompetition = data["is_competition"] as? Int {
            self.isCompetition = isCompetition == 1 ? true : false
            if isCompetition == 1 {
                if let eventCompetition = data["competition"] as? [String: AnyObject] {
                    self.competition = Competition(data: eventCompetition)
                }
            }
        } else {
            self.isCompetition = false
        }
        
        if let showData = data["show_data"] as? [[String: AnyObject]] {
            self.showData = ShowData(showDataCollection: showData)
        } else {
            self.showData = nil
        }
    }
}


class EventImproved {
    
    let id: Int?
    let type: String?
    let name: String?
    let rating: Double?
    let imageUrl: NSURL?
    let description: String?
    let priceFrom: Double?
    let priceTo: Double?
    let fullPriceString: String?
    let ourPriceString: String?
    let ourPriceHeading: String?
    let membershipLevels: String?
    let soldOut: Bool?
    let comingSoon: Bool?
    let isCompetition: Bool?
    var competition: Competition?
    let showDataCollection : [ShowDataImproved]?
    
    var eventShowList : [Show] {
        var showList: [Show] = []
        for showData in self.showDataCollection! {
            for show in showData.shows {
                showList.append(show)
            }
        }
        return showList
    }
    
    var associatedVenue: Venue? {
        if let showDataCollection = self.showDataCollection {
            if let showData = showDataCollection.first {
                if let venue = showData.venue {
                    print(venue.venueName)
                    return venue
                }
            }
        }
        return nil
    }
    
    var thumbNailImage: UIImage? {
        get {
            let data = NSData(contentsOfURL: self.imageUrl!)
            return UIImage(data: data!)
        }
    }
    
    var getPrettyPriceHeading: String {
        get {
            var finalString = ""
            if let priceHeading = self.ourPriceHeading {
                print(priceHeading)
                switch priceHeading.lowercaseString {
                case "On The House DISCOUNTED TICKET PRICE".lowercaseString:
                    finalString = "Discounted Price"
                    break
                case "On The House Admin Fee".lowercaseString:
                    finalString = "Admin Fee"
                    break
                default:
                    break
                }
            }
            return finalString
        }
    }
    
    var goldLogoVisibility: Bool {
        get {
            if let memberShip = self.membershipLevels {
                return memberShip.lowercaseString.containsString("gold") ? false : true
            }
            return true
        }
    }
    
    var bronzeLogoVisibility: Bool {
        get {
            if let memberShip = self.membershipLevels {
                return memberShip.lowercaseString.containsString("bronze") ? true : false
            }
            return true
        }
    }
    
    var memberShipLevelID: Int? {
        if let memberShipString = self.membershipLevels {
            print(memberShipString)
            let finalMemberShipString = memberShipString.lowercaseString
            
            if finalMemberShipString.containsString("gold") && !finalMemberShipString.containsString("bronze") {
                return 9
            } else if finalMemberShipString.containsString("bronze") && finalMemberShipString.containsString("gold") {
                return 3
            }
            return nil
        }
        return nil
    }
    
    func canUserEnterCompetition() -> Bool {
        let userMemberLevelID = NSUserDefaults.standardUserDefaults().integerForKey("membership_level")
        var value = false
        switch(self.memberShipLevelID!, userMemberLevelID) {
        case(MemberShip.Bronze.levelID, MemberShip.Bronze.levelID):
            value = true
            break
        case(MemberShip.Bronze.levelID, MemberShip.Gold.levelID):
            value = true
            break
        case(MemberShip.Gold.levelID, MemberShip.Bronze.levelID):
            value = false
            break
        case(MemberShip.Gold.levelID, MemberShip.Gold.levelID):
            value = true
            break
        default:
            break
        }
        return value
    }
    
    init(data: [String: AnyObject]) {
        
        if let id = data["id"] as? String {
            self.id = Int(id)
        }  else {
            self.id = 0
        }
        
        if let type = data["type"] as? String {
            self.type = type
        }  else {
            self.type = ""
        }
        
        if let name = data["name"] as? String {
            self.name = name
        }  else {
            self.name = ""
        }
        
        if let rating = data["rating"] as? Int {
            self.rating = Double(rating)
        }  else {
            self.rating = 0.0
        }
        
        if let description = data["description"] as? String {
            self.description = description
            
        }  else {
            self.description = ""
        }
        
        if let imageUrl = data["image_url"] as? String {
            self.imageUrl = NSURL(string: imageUrl)!
        }  else {
            self.imageUrl = NSURL()
        }
        
        if let priceFrom = data["price_from"] as? Double {
            self.priceFrom = priceFrom
        }  else {
            self.priceFrom = 0.0
        }
        
        if let priceTo = data["price_to"] as? Double {
            self.priceTo = priceTo
        }  else {
            self.priceTo = 0.0
        }
        
        if let fullPriceString = data["full_price_string"] as? String {
            self.fullPriceString = fullPriceString
        }  else {
            self.fullPriceString = ""
        }
        
        if let ourPriceHeading = data["our_price_heading"] as? String {
            self.ourPriceHeading = ourPriceHeading
        }  else {
            self.ourPriceHeading = ""
        }
        
        if let ourPriceString = data["our_price_string"] as? String {
            self.ourPriceString = ourPriceString
        }  else {
            self.ourPriceString = ""
        }
        
        if let membershipLevels = data["membership_levels"] as? String {
            self.membershipLevels = membershipLevels
        }  else {
            self.membershipLevels = ""
        }
        
        if let soldOut = data["sold_out"] as? Int {
            self.soldOut = soldOut == 1 ? true : false
        }  else {
            self.soldOut = false
        }
        
        if let comingSoon = data["coming_soon"] as? Int {
            self.comingSoon = comingSoon == 1 ? true : false
        }  else {
            self.comingSoon = false
        }
        
        if let isCompetition = data["is_competition"] as? Bool {
            print("competition - parsing as bool \(isCompetition)")
            self.isCompetition = isCompetition
            if self.isCompetition  == true {
                if let eventCompetition = data["competition"] as? [String: AnyObject] {
                    self.competition = Competition(data: eventCompetition)
                }
            }
        } else {
            self.isCompetition = false
        }
        
        if let showDataList = data["show_data"] as? [[String: AnyObject]] {
            self.showDataCollection = []
            for showData in showDataList {
                self.showDataCollection?.append(ShowDataImproved(data: showData))
            }
        } else {
            self.showDataCollection  = nil
        }
    }
}

class ShowDataImproved {
    var venue: Venue?
    var shows: [Show] = []
    
    init(data: [String: AnyObject]) {
        
        self.venue = Venue(data: (data["venue"] as? [String: AnyObject])!)
        
        let showArray = data["shows"] as? [[String: AnyObject]]
        for show in showArray! {
            let currentShow = Show(data: show)
            self.shows.append(currentShow)
        }
        
    }
}

class ShowData {
    var venue: Venue?
    var shows: [Show] = []
    
    init(showDataCollection: [[String: AnyObject]]) {
        for showData in showDataCollection {
            self.venue = Venue(data: (showData["venue"] as? [String: AnyObject])!)
            let showArray = showData["shows"] as? [[String: AnyObject]]
            for show in showArray! {
                let currentShow = Show(data: show)
                self.shows.append(currentShow)
            }
        }
    }
}

class Venue {
    
    let venueID: Int?
    let supplierId: Int?
    let venueName: String?
    let addressLineOne: String?
    let addressLineTwo: String?
    let city: String?
    let stateID: Int?
    let zip: Int?
    let countryID: Int?
    let state: String?
    let country: String?
    
    
    init(data: [String: AnyObject]) {
        
        if let venueID = data["id"] as? String {
            self.venueID = Int(venueID)
        } else {
            self.venueID = 0
        }
        
        if let supplierID = data["supplier_id"] as? String {
            print(supplierID)
            self.supplierId = Int(supplierID)
        } else {
            self.supplierId = 0
        }
        
        if let venueName = data["name"] as? String {
            self.venueName = venueName
        } else {
            self.venueName = ""
        }
        
        if let addressLineOne = data["address1"] as? String {
            self.addressLineOne = addressLineOne
        } else {
            self.addressLineOne = ""
        }
        
        if let addressLineTwo = data["address2"] as? String {
            self.addressLineTwo = addressLineTwo
        } else {
            self.addressLineTwo = ""
        }
        
        if let city = data["city"] as? String {
            self.city = city
        } else {
            self.city = ""
        }
        
        if let zoneID = data["zone_id"] as? String {
            self.stateID = Int(zoneID)
        } else {
            self.stateID = 0
        }
        
        if let zip = data["zip"] as? String {
            self.zip = Int(zip)
        } else {
            self.zip = 0
        }
        
        if let countryID = data["country_id"] as? String {
            self.countryID = Int(countryID)
        } else {
            self.countryID = 0
        }
        
        if let state = data["zone_name"] as? String {
            self.state = state
        } else {
            self.state = ""
        }
        
        if let country = data["country_name"] as? String {
            self.country = country
        } else {
            self.country = ""
        }
    }
    
    var addressForGeocoder: String {
        
        var finalAddress = ""
        let space = " "
        if let venueName = self.venueName {
            finalAddress += venueName + space
        }
        
        if let address1 = self.addressLineOne {
            finalAddress += address1 + space
        }
        
        if let address2 = self.addressLineTwo {
            finalAddress += address2 + space
        }
        
        if let city = self.city {
            finalAddress += city + space
        }
        
        if let zip = self.zip {
            finalAddress += String(zip) + space
        }
        
        if let zoneName = self.state {
            finalAddress += zoneName + space
        }
        
        if let country = self.country {
            finalAddress += country
        }
        return finalAddress
    }
    
    var addressForAnnotationView: String {
        var finalAddress = ""
        let space = " "
        
        if let address1 = self.addressLineOne {
            finalAddress += address1 + space
        }
        
        if let address2 = self.addressLineTwo {
            finalAddress += address2 + space
        }
        
        if let city = self.city {
            finalAddress += city + space
        }
        
        if let state = self.state {
            finalAddress += state + space
        }
    
        return finalAddress
    }
}

class Show {
    
    let showID: Int?
    let eventID: Int?
    let venueID: Int?
    let pickUpVenueID: Int?
    let cutOffDate: NSDate?
    let totalTickets: Int?
    let reservedTickets: Int?
    let timeZoneID: Int?
    let price: Double?
    let maximumTicketsPerMember: Int?
    let isAdminFee: Bool?
    let memberShipLevelID: Int?
    let memberCanChoose: Bool?
    let dateHide: Bool?
    let timeHide: Bool?
    let shipping: Bool?
    let shippingPrice: Double?
    let soldOut: Bool?
    let formattedDateTime: String?
    let allowedQuantity: [Int]?
    let rawShowDateOne: Double?
    let rawShowDateTwo: Double?
    
    
    var showDateOne: NSDate? {
        get {
            return(NSDate(timeIntervalSince1970: self.rawShowDateOne!))
        }
        set {
            self.showDateOne = NSDate(timeIntervalSince1970: self.rawShowDateOne!)
        }
    }
    
    var showDateTwo: NSDate? {
        get {
            return(NSDate(timeIntervalSince1970: self.rawShowDateTwo!))
        }
        set {
            self.showDateTwo = NSDate(timeIntervalSince1970: self.rawShowDateTwo!)
        }
    }
    
    var humanReadableTimeStringFrom: String {
        get {
            return timeStringFromUnixTime(self.rawShowDateOne!)
        }
    }
    
    var humanReadableTimeStringTo: String {
        get {
            return timeStringFromUnixTime(self.rawShowDateTwo!)
        }
    }
    
    var humanReadableDateStringFrom: String {
        get {
            return dateStringFromTime(self.rawShowDateOne!)
        }
    }
    
    var humanReadableDateStringTo: String {
        get {
            return dateStringFromTime(self.rawShowDateTwo!)
        }
    }
    
    var memberShipExplainationText: String {
        get {
            return self.memberShipLevelID == 3 ? "Gold & Bronze Member Event" : "Gold Member Event"
        }
    }
    
    func isBookable() -> Bool {
        let userMemberLevelID = NSUserDefaults.standardUserDefaults().integerForKey("membership_level")
        var value = false
        switch(self.memberShipLevelID!, userMemberLevelID) {
        case(MemberShip.Bronze.levelID, MemberShip.Bronze.levelID):
            value = true
            break
        case(MemberShip.Bronze.levelID, MemberShip.Gold.levelID):
            value = true
            break
        case(MemberShip.Gold.levelID, MemberShip.Bronze.levelID):
            value = false
            break
        case(MemberShip.Gold.levelID, MemberShip.Gold.levelID):
            value = true
            break
        default:
            break
        }
        return value
    }
    
    init(data: [String: AnyObject]) {
        
        if let showID = data["id"] as? String {
            self.showID = Int(showID)
        } else {
            self.showID = 0
        }
        
        if let eventID = data["event_id"] as? String {
            self.eventID = Int(eventID)
        } else {
            self.eventID = 0
        }
        
        if let venueID = data["venue_id"] as? String {
            self.venueID = Int(venueID)
        } else {
            self.venueID = 0
        }
        
        if let pickUpVenueID = data["pickup_venue_id"] as? String {
            self.pickUpVenueID = Int(pickUpVenueID)
        } else {
            self.pickUpVenueID = 0
        }
        
        if let showDateOne = data["show_date"] as? String {
            self.rawShowDateOne = Double(showDateOne)
        } else {
            self.rawShowDateOne = 0.0
        }
        
        if let showDateTwo = data["show_date2"] as? String {
            self.rawShowDateTwo = Double(showDateTwo)
        } else {
            self.rawShowDateTwo = 0.0
        }
        
        if let cutOffDate = data["cutoff_date"] as? String {
            self.cutOffDate = NSDate(timeIntervalSince1970: Double(cutOffDate)!)
        } else {
            self.cutOffDate = NSDate()
        }
        
        if let totalTickets = data["total_tickets"] as? String {
            self.totalTickets = Int(totalTickets)
        } else {
            self.totalTickets = 0
        }
        
        if let reservedTickets = data["tickets_reserved"] as? String {
            self.reservedTickets = Int(reservedTickets)
        } else {
            self.reservedTickets = 0
        }
        
        if let timeZoneID = data["timezone_id"] as? String {
            self.timeZoneID = Int(timeZoneID)
        } else {
            self.timeZoneID = 0
        }
        
        if let price = data["price"] as? String {
            self.price = Double(price)
        } else {
            self.price = 0.0
        }
        
        if let maximumTicketsPerMember = data["max_tickets_per_member"] as? String {
            self.maximumTicketsPerMember = Int(maximumTicketsPerMember)
        } else {
            self.maximumTicketsPerMember = 0
        }
        
        if let isAdminFee = data["is_admin_fee"] as? String {
            self.isAdminFee = Int(isAdminFee) == 1 ? true : false
        } else {
            self.isAdminFee = false
        }
        
        if let memberShipLevelID = data["membership_level_id"] as? String {
            self.memberShipLevelID = Int(memberShipLevelID)
        } else {
            self.memberShipLevelID = 0
        }
        
        if let memberCanChoose = data["member_can_choose"] as? String {
            self.memberCanChoose = Int(memberCanChoose) == 1 ? true : false
        } else {
            self.memberCanChoose = false
        }
        
        if let dateHide = data["date_hide"] as? String {
            self.dateHide = Int(dateHide) == 1 ? true : false
        } else {
            self.dateHide = false
        }
        
        if let timeHide = data["time_hide"] as? String {
            self.timeHide = Int(timeHide) == 1 ? true : false
        } else {
            self.timeHide = false
        }
        
        if let shipping = data["shipping"] as? String {
            self.shipping = Int(shipping) == 1 ? true : false
        } else {
            self.shipping = false
        }
        
        if let shippingPrice = data["shipping_price"] as? String {
            self.shippingPrice = Double(shippingPrice)
        } else {
            self.shippingPrice = 0.0
        }
        
        if let soldOut = data["sold_out"] as? Bool {
            self.soldOut = soldOut
        } else {
            self.soldOut = false
        }
        
        if let formattedDateTime = data["date_formatted"] as? String {
            self.formattedDateTime = formattedDateTime
        } else {
            self.formattedDateTime = ""
        }
        
        if let allowedQuantity = data["quantities"] as? [Int] {
            self.allowedQuantity = allowedQuantity
        } else {
            self.allowedQuantity = []
        }
    }
}



class Competition {
    
    let status: String?
    let question: String?
    let startDate: NSDate?
    let endDate: NSDate?
    let dateFromRaw: Double?
    let dateToRaw: Double?
    
    var humanReadableDayFrom: String {
        get {
            return dayStringFromTime(dateFromRaw!)
        }
    }
    
    var humanReadableDayTo: String {
        get {
            return dayStringFromTime(dateToRaw!)
        }
    }
    
    var humanReadableDateFrom: String {
        get {
            return dateStringFromTime(dateFromRaw!)
        }
    }
    
    var humanReadableDateTo: String {
        get {
            return dateStringFromTime(dateToRaw!)
        }
    }
    
    var humanReadableTimeFrom: String {
        get {
            return timeStringFromUnixTime(dateFromRaw!)
        }
    }
    
    var humanReadableTimeTo: String {
        get {
            return timeStringFromUnixTime(dateToRaw!)
        }
    }
    
    var canEnterCompetition: Bool {
        guard let startDate = self.startDate, endDate = self.endDate else {
            return false
        }
        let currentDate = NSDate()
        let boolValue = (currentDate.isEqualToDate(startDate) || currentDate.isGreaterThanDate(startDate)) &&
            (currentDate.isLessThanDate(endDate) || currentDate.isEqualToDate(endDate))
        
        return boolValue
    }
    
    init(data: [String: AnyObject]) {
        
        if let status = data["status"] as? String {
            self.status = status
        } else {
            self.status = nil
        }
        
        if let dateFrom = data["date_from"] as? String {
            self.dateFromRaw = Double(dateFrom)
            if let date = dateFromRaw {
                self.startDate = NSDate(timeIntervalSince1970: date)
            } else {
                self.startDate = nil
            }
        } else {
            self.dateFromRaw = 0.0
            self.startDate = nil
        }
        
        if let dateTo = data["date_to"] as? String {
            self.dateToRaw = Double(dateTo)
            if let date = self.dateToRaw {
                self.endDate = NSDate(timeIntervalSince1970: date)
            } else {
                self.endDate = nil
            }
        } else {
            self.dateToRaw = 0.0
            self.endDate = nil
        }
        
        if let question = data["question"] as? String {
            self.question = question
        } else {
            self.question = ""
        }
        
        
    }
}

class MemberShipLevel {
    
    let id: Int?
    let name: String?
    let level: Int?
    let price: Double?
    let durationType: Int?
    let durationAmount: Int?
    let description: String?
    
    init(data: [String: AnyObject]) {
        
        if let id = data["id"] as? String {
            self.id = Int(id)
        } else {
            self.id = nil
        }
        
        if let name = data["name"] as? String {
            self.name = name
        } else {
            self.name = nil
        }
        
        if let level = data["level"] as? String {
            self.level = Int(level)
        } else {
            self.level = nil
        }
        
        if let price = data["price"] as? String {
            self.price = Double(price)
        } else {
            self.price = nil
        }
        
        if let durationType = data["duration_type"] as? String {
            self.durationType = Int(durationType)
        } else {
            self.durationType = nil
        }
        
        if let durationAmount = data["duration_amount"] as? String {
            self.durationAmount = Int(durationAmount)
        } else {
            self.durationAmount = nil
        }
        
        if let description = data["description"] as? String {
            self.description = description
        } else {
            self.description = nil
        }
    }
}



class Membership {
    
    let memberId: Int?
    let membershiplevelId: Int?
    let membershiplevelName: String?
    let dateCreated: Double?
    let dateExpire: Double?
    let price: Float?
    
    init(data: [String: AnyObject]) {
        
        if let memberId = data["member_id"] as? String {
            self.memberId = Int(memberId)
        } else {
            self.memberId = 0
        }
        
        if let membershiplevelId = data["membership_level_id"] as? String {
            self.membershiplevelId = Int(membershiplevelId)
        }   else {
            self.membershiplevelId = 0
        }
        
        if let  membershiplevelName = data["membership_level_name"] as? String {
            self.membershiplevelName = String(membershiplevelName)
        }  else {
            self.membershiplevelName =  nil
        }
        
        if let  dateCreated = data["date_created"] as? String {
            self.dateCreated = Double(dateCreated)
        }  else {
            self.dateCreated =  nil
        }
        
        if let  dateExpire = data["date_expires"] as? String {
            self.dateExpire = Double(dateExpire)
        }  else {
            self.dateExpire =  nil
        }
        
        if let price = data["price"] as? String {
            self.price = Float(price)
        } else {
            self.price = 0.0
        }
        
    }
    
    var membershipStartDate: String? {
        get {
            return dateStringFromTime(self.dateCreated!)
        }
    }
    
    var membershipExpiryDate: String? {
        get {
            return dateStringFromTime(self.dateExpire!)
        }
    }
}
