//
//  Member.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 18/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation

class Member {
    
    let id: Int?
    let nickName: String?
    let title: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let ageGroup: String?
    let phone: String?
    
    let membershipLevelID: Int?
    let countryID: Int?
    var stateID: Int?
    let timezoneID: Int?
    let city: String?
    let zip: Int?
    let addressLineOne: String?
    let addressLineTwo: String?
    var categoryList: [Int] = []
    var languageList: [Int] = []
    var defaults = NSUserDefaults?()
    
    init(data: [String: AnyObject]) {
        self.defaults = NSUserDefaults.standardUserDefaults()
        if let id = data["id"] as? String {
            print(id)
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "loggin_in")
            self.id = Int(id)
            defaults!.setInteger(self.id!, forKey: "id")
        } else {
            self.id = nil
        }
        
        if let title = data["title"] as? String {
            self.title = title
            defaults?.setObject(self.title, forKey: "title")
        } else {
            self.title = nil
        }
        
        if let focusgroup = data["focus_groups"] as? String {
            let  focusgrp = Int(focusgroup)
            print("member focus group \(focusgrp)")
            if let focusGroup = focusgrp {
                NSUserDefaults.standardUserDefaults().setBool(focusGroup == 1 ? true : false, forKey: "focusGroups")
            }
        }
        
        if let newsletters = data["newsletters"] as? String {
            let  newsletter = Int(newsletters)
            print("newsletter \(newsletter)")
            if let newsletter = newsletter {
                NSUserDefaults.standardUserDefaults().setBool(newsletter == 1 ? true : false, forKey: "newsLetters")
            }
        }
        
        if let paidmarketing = data["paid_marketing"] as? String {
            let  paidmarket  = Int(paidmarketing)
            print("paid marketing \(paidmarket)")
            if let paidMarketing = paidmarket {
                NSUserDefaults.standardUserDefaults().setBool(paidMarketing == 1 ? true : false, forKey: "paidMarketing")
            }
        }
        
        if let nickname = data["nickname"] as? String {
            self.nickName = nickname
            defaults?.setObject(self.nickName, forKey: "nickName")
        } else {
            self.nickName = nil
        }
        
        if let firstName = data["first_name"] as? String {
            self.firstName = firstName
            defaults?.setObject(self.firstName, forKey: "firstName")
        } else {
            self.firstName = nil
        }
        
        if let lastName = data["last_name"] as? String {
            self.lastName = lastName
            defaults?.setObject(self.lastName, forKey: "lastName")
        } else {
            self.lastName = nil
        }
        
        
        if let email = data["email"] as? String {
            self.email = email
            defaults?.setObject(self.email, forKey: "email")
        } else {
            self.email = nil
        }
        
        if let age = data["age"] as? String {
            self.ageGroup = age
            defaults?.setObject(self.ageGroup, forKey: "ageGroup")
        } else {
            self.ageGroup = nil
        }
        
        if let phone = data["phone"] as? String {
            self.phone = phone
            defaults?.setObject(self.phone, forKey: "phone")
        } else {
            self.phone = nil
        }
        
        if let memberShipID = data["membership_level_id"] as? String {
            self.membershipLevelID = Int(memberShipID)
            defaults!.setInteger(self.membershipLevelID!, forKey: "membership_level")
            print(membershipLevelID)
        } else {
            self.membershipLevelID = nil
        }
        
        if let memberCountry = data["country_id"] as? String {
            self.countryID = Int(memberCountry)
            print(countryID)
            defaults!.setInteger(self.countryID!, forKey: "country")
        } else {
            self.countryID = nil
        }
        
        if let memberState = data["zone_id"] as? String {
            self.stateID = Int(memberState)
            stateID = 216 //hard coding
            defaults!.setInteger(self.stateID!, forKey: "state")
        } else {
            self.stateID = nil
        }
        
        if let memberTimeZone = data["timezone_id"] as? String {
            self.timezoneID = Int(memberTimeZone)
            print(self.timezoneID)
            defaults!.setInteger(self.timezoneID!, forKey: "timezone")
        } else {
            self.timezoneID = nil
        }
        
        if let memberZip = data["zip"] as? String {
            self.zip = Int(memberZip)
            print(self.zip)
            defaults!.setInteger(self.zip!, forKey: "zip")
        } else {
            self.zip = nil
        }
        
        
        if let addressOne = data["address1"] as? String {
            self.addressLineOne = addressOne
            print(self.addressLineOne)
            defaults!.setObject(self.addressLineOne, forKey: "address1")
        } else {
            self.addressLineOne = nil
        }
        
        if let addressTwo = data["address2"] as? String {
            self.addressLineTwo = addressTwo
            defaults!.setObject(self.addressLineTwo!, forKey: "address2")
        } else {
            self.addressLineTwo = nil
        }
        
        
        
        if let city = data["city"] as? String {
            self.city = city
            defaults!.setObject(self.city, forKey: "city")
        } else {
            self.city = nil
        }
        
        if let categoryString = data["categories"] as? String {
            let splitedString = categoryString.componentsSeparatedByString(",")
            for item in splitedString {
                if let value = Int(item) {
                    self.categoryList.append(value)
                }
            }
            print("category --- check this ------")
            print(self.categoryList)
            defaults!.setObject(self.categoryList, forKey: "categories")
        } else {
            print("category empty")
            self.categoryList = []
        }
        
        if let languageString = data["language_id"] as? String {
            print(languageString)
            let splitedString = languageString.componentsSeparatedByString(",")
            for item in splitedString {
                if let value = Int(item) {
                    self.languageList.append(value)
                }
            }
            print("Language")
            print(self.languageList)
            defaults!.setObject(self.languageList, forKey: "languages")
        } else {
            print("language empty")
            self.languageList = []
        }
    }
    
}

// Member Reservation Current

class MemberReservation {
    let reservationId: Int?
    let eventName: String?
    let eventDate: String?
    let ticketQuantity: Int?
    let venueID: Int?
    let venueName: String?
    let type: String?
    let canCancel: Bool?
    let canRate: Bool?
    let hasRated: Bool?
    let eventId: Int?
    init(data: [String: AnyObject]) {
        if let name = data["event_name"] as? String {
            self.eventName = name
        } else {
            self.eventName = nil
        }
        
        if let reservationID = data["reservation_id"] as? String {
            self.reservationId = Int(reservationID)
        } else {
            self.reservationId = nil
        }
        
        if let eventDate = data["date"] as? String {
            self.eventDate = eventDate
        } else {
            self.eventDate = nil
        }
        
        if let quantity = data["num_tickets"] as? String {
            if let value = Int(quantity) {
                self.ticketQuantity = value
            } else {
                self.ticketQuantity = nil
            }
        } else {
            self.ticketQuantity = nil
        }
        
        if let venueId = data["venue_id"] as? String {
            if let value = Int(venueId) {
                self.venueID = value
            } else {
                self.venueID = nil
            }
        } else {
            self.venueID = nil
        }
        
        if let venueName = data["venue_name"] as? String {
            self.venueName = venueName
        } else {
            self.venueName = nil
        }
        
        if let type = data["type"] as? String {
            self.type = type
        } else {
            self.type = nil
        }
        
        if let canRate = data["can_rate"] as? Bool {
            self.canRate = canRate
        } else {
            self.canRate = nil
        }
        
        if let canCancel = data["can_cancel"] as? Bool {
            self.canCancel = canCancel
        } else {
            self.canCancel = nil
        }
        
        if let hasRated = data["has_rated"] as? Bool {
            self.hasRated = hasRated
        } else {
            self.hasRated = nil
        }
        
        if let id =     data["event_id"] as? String {
            let eventId = Int(id)
            self.eventId = eventId
        } else {
            self.eventId = nil
        }

        
        
        
    }
}

struct PreferenceData {
    
    static func dataParser(data: [String: AnyObject]) {
        print("inside Preference data parser")
        
        if let newsletter = data["newsletters"] as? Int {
            NSUserDefaults.standardUserDefaults().setBool(newsletter == 1 ? true : false, forKey: "newsLetters")
            print(newsletter)
        } else {
            print("cant cast into int")
        }
        
        if let focusGroup = data["focus_groups"] as? Int {
            NSUserDefaults.standardUserDefaults().setBool(focusGroup == 1 ? true : false, forKey: "focusGroups")
            print(focusGroup)
        } else {
            print("cant cast into int")
        }
        
        if let paidMarketing = data["paid_marketing"] as? Int {
            NSUserDefaults.standardUserDefaults().setBool(paidMarketing == 1 ? true : false, forKey: "paidMarketing")
            print(paidMarketing)
        } else {
            print("cant cast into int")
        }
        
        if let categoryString = data["categories"] as? String {
            var categoryList: [Int] = []
            let splitedString = categoryString.componentsSeparatedByString(",")
            for item in splitedString {
                if let value = Int(item) {
                    categoryList.append(value)
                }
            }
            print("category --- check this ------")
            NSUserDefaults.standardUserDefaults().setObject(categoryList, forKey: "categories")
        } else {
            print("category empty")
        }
        
        print("newsletter")
        print(NSUserDefaults.standardUserDefaults().boolForKey("newsLetters"))
        
        print("paid marketing")
        print(NSUserDefaults.standardUserDefaults().boolForKey("paidMarketing"))
        
        print("focusGroups")
        print(NSUserDefaults.standardUserDefaults().boolForKey("focusGroups"))
        
    }
}
