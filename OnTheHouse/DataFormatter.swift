//
//  DataFormatter.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 13/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import UIKit

struct Category {
    var id: Int = 0
    var name: String = ""
}

struct State {
    var id: Int = 0
    var name: String = ""
}

struct Country {
    var id: Int = 0
    var name: String = ""
}

struct Language {
    var id: Int
    var name: String
}

struct TimeZone {
    var id: Int
    var name: String
}


struct Question {
    var questionID: Int = 0
    var questionName: String = ""
    var isMultipart: Bool = false
}

enum QuesTionType: Int {
    case Social = 1, Booking
}

struct APIStatus {
    static func isSuccessfulResponse(data: [String: AnyObject]?) -> Bool {
        if let data = data {
            if let status = data["status"] as? String {
                switch(status) {
                case "success":
                    return true
                case "error":
                    return false
                default:
                    break
                }
            }
        }
        return false
    }
    
    static func retrieveErrorMessage(data: [String: AnyObject]?) -> [String]? {
        var messageList: [String] = []
        if let data = data {
            if let errorObject = data["error"] as? [String: AnyObject] {
                if let messages = errorObject["messages"] as? [String] {
                    for message in messages {
                        messageList.append(message)
                    }
                    return messageList
                }
            }
        }
        return nil
    }
    
    static func showAlertMessageToUser(message: [String]?) -> UIAlertController? {
        var alertMessage = ""
        if let messages = message {
            for i in 0..<messages.count {
                if i != messages.count - 1 {
                    alertMessage += messages[i] + "\n"
                } else {
                    alertMessage += messages[i]
                }
            }
            let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(alertAction)
            return alertController
        }
        return nil
    }
}



struct DataFormatter {
    static func getListOfEvents(jsonDictionary: [String: AnyObject]?) -> [Event] {
        if jsonDictionary != nil {
            if let eventsDictionaryList = jsonDictionary!["events"] as? [[String: AnyObject]] {
                var eventList: [Event] = []
                for individualEventDictionary in eventsDictionaryList {
                    eventList.append(Event(data: individualEventDictionary))
                }
                return eventList
            }
        }
        return []
    }
    
    static func getMemberShipObject(jsonDictionary: [String: AnyObject]?) -> [Membership] {
        if jsonDictionary != nil {
            if let membershipData = jsonDictionary!["membership"] as? [String: AnyObject] {
                var membership: [Membership] = []
                membership.append(Membership(data: membershipData))
                return membership
            }
        }
        return []
    }
    
    static func getListOfMemberShipLevels(jsonDictionary: [String: AnyObject]?) -> [MemberShipLevel] {
        if jsonDictionary != nil {
            if let memberShipDictionaryList = jsonDictionary!["membership_levels"] as? [[String: AnyObject]] {
                var memberShipLevelList: [MemberShipLevel] = []
                for individualMemberShipDictionary in  memberShipDictionaryList {
                    memberShipLevelList.append(MemberShipLevel(data: individualMemberShipDictionary))
                }
                return memberShipLevelList
            }
        }
        return []
    }
    
    static func getListOfCountries(jsonDictionary: [String: AnyObject]?) -> [String] {
        var countryList: [String] = []
        if let data = jsonDictionary {
            let countryArray = data["countries"] as? [[String: AnyObject]]
            for country in countryArray! {
                for (key, value) in country.enumerate() {
                    if key == 3 && value.0 == "name" {
                        countryList.append(value.1 as! String)
                    }
                }
            }
            
        }
        return countryList
    }
    
    static func getListOfCountriesEnhanced(jsonDictionary: [String: AnyObject]?) -> [Country] {
        var countryList: [Country] = []
        if let data = jsonDictionary {
            let countryArray = data["countries"] as? [[String: AnyObject]]
            for country in countryArray! {
                var countryName = ""
                var countryID = 0
                for (key, value) in country.enumerate() {
                    if key == 3 && value.0 == "name" {
                        //countryList.append(value.1 as! String)
                        countryName = value.1 as! String
                    }
                    if key == 0 && value.0 == "id" {
                        //countryList.append(value.1 as! String)
                        countryID = Int(value.1 as! String)!
                    }
                }
                countryList.append(Country(id: countryID, name: countryName))
            }
            
        }
        return countryList
    }
    
    static func getListOfMemberAges(jsonDictionary: [String: AnyObject]?) -> [String] {
        var memberAgesList: [String] = []
        if let data = jsonDictionary {
            memberAgesList = (data["member_ages"] as? [String])!
        }
        return memberAgesList
    }
    
    static func getListOfString(jsonDictionary: [String: AnyObject]?) -> [String] {
        var stringList: [String] = []
        if let data = jsonDictionary {
            stringList = (data["member_titles"] as? [String])!
        }
        return stringList
    }
    
    static func getListOfStates(jsonDictionary: [String: AnyObject]?) -> [State]{
        var stateObjectList: [State] = []
        if let data = jsonDictionary {
            let countryArray = data["zones"] as? [[String: AnyObject]]
            for country in countryArray! {
                var stateName = ""
                var stateID = 0
                for (key, value) in country.enumerate() {
                    //print("\(key)  ----- \(value.0)  \(value.1)")
                    if key == 2 && value.0 == "id" {
                        if let id = value.1 as? String {
                            stateID = Int(id)!
                        }
                    }
                    if key == 3 && value.0 == "name" {
                        if let name = value.1 as? String {
                            stateName = name
                        }
                    }
                }
                stateObjectList.append(State(id: stateID, name: stateName))
            }
        }
        return stateObjectList
    }
    
    static func getListOfLanguages(jsonDictionary: [String: AnyObject]?) -> [Language] {
        var languageList: [Language] = []
        if let data = jsonDictionary {
            let languageArray = data["languages"] as? [[String: AnyObject]]
            for language in languageArray! {
                var languageName = ""
                var languageID = 0
                for (key, value) in language.enumerate() {
                    
                    //print("\(key)  ----- \(value.0)  \(value.1)")
                    
                    if key == 0 && value.0 == "name" {
                        if let name = value.1 as? String {
                            languageName = name
                        }
                    }
                    
                    if key == 1 && value.0 == "id" {
                        if let id = value.1 as? String {
                            languageID = Int(id)!
                        }
                    }
                }
                languageList.append(Language(id: languageID, name: languageName))
            }
        }
        return languageList
    }
    
    static func getListOfCategories(jsonDictionary: [String: AnyObject]?) -> [Category] {
        var categoryList: [String] = []
        var categoryObjectList: [Category] = []
        if let data = jsonDictionary {
            let categoryArray = data["categories"] as? [[String: AnyObject]]
            for category in categoryArray! {
                var categoryName = ""
                var categoryID = 0
                for (key, value) in category.enumerate() {
                    
                    if key == 4 && value.0 == "name" {
                        categoryList.append((value.1 as? String)!)
                        if let name = value.1 as? String {
                            categoryName = name
                        }
                    }
                    
                    if key == 2 && value.0 == "id" {
                        categoryList.append((value.1 as? String)!)
                        if let id = value.1 as? String {
                            categoryID = Int(id)!
                        }
                    }
                    //print("\(key)  ----- \(value.0)  \(value.1)")
                }
                categoryObjectList.append(Category(id: categoryID, name: categoryName))
            }
            
        }
        return categoryObjectList
    }
    
    static func getListOfStatesByCountryID(jsonDictionary: [String: AnyObject]?) -> [String] {
        var stateList: [String] = []
        if let data = jsonDictionary {
            let countryArray = data["zones"] as? [[String: AnyObject]]
            for country in countryArray! {
                for (key, value) in country.enumerate() {
                    if key == 3 && value.0 == "name" {
                        stateList.append(value.1 as! String)
                    }
                }
            }
            
        }
        return stateList
    }
    
    static func getTimeZonesAsList(jsonDictionary: [String: AnyObject]?) -> [String] {
        var timeZonesList: [String] = []
        if let data = jsonDictionary {
            guard let timeZoneArray = data["timezones"] as? [[String: AnyObject]] else {
                print("Wrong Key")
                return []
            }
            for timeZone in timeZoneArray {
                for (key, value) in timeZone.enumerate() {
                    //print("Key: \(key)  Value: \(value.0)   \(value.1)")
                    if key == 0 && value.0 == "name" {
                        timeZonesList.append(value.1 as! String)
                    }
                }
            }
            
        }
        return timeZonesList
    }
    
    static func getTimeZones(jsonDictionary: [String: AnyObject]?) -> [TimeZone] {
        var timeZonesList: [TimeZone] = []
        if let data = jsonDictionary {
            guard let timeZoneArray = data["timezones"] as? [[String: AnyObject]] else {
                print("Wrong Key")
                return []
            }
            for timeZone in timeZoneArray {
                var id = 0
                var name = ""
                for (key, value) in timeZone.enumerate() {
                    //print("Key: \(key)  Value: \(value.0)   \(value.1)")
                    if key == 0 && value.0 == "name" {
                        name = value.1 as! String
                    }
                    if key == 2 && value.0 == "id" {
                        id = Int(value.1 as! String)!
                    }
                }
                timeZonesList.append(TimeZone(id: id, name: name))
            }
        }
        return timeZonesList
    }
    
    static func getQuestionSetAsDictionary(jsonDictionary: [String: AnyObject]?) -> [Question] {
        var questionsList: [Question] = []
        if let data = jsonDictionary {
            guard let questionsArray = data["questions"] as? [[String: AnyObject]] else {
                print("Wrong Key")
                return []
            }
            for question in questionsArray {
                var currentQuestion = Question()
                currentQuestion.questionName = (question["question_name"] as? String)!
                currentQuestion.isMultipart = (question["is_multiple"] as? String)! == "yes" ? true : false
                questionsList.append(currentQuestion)
            }
            
        }
        return questionsList
    }
    
    static func getCustomQuestionSetAsDictionary(questionCategory: QuesTionType, jsonDictionary: [String: AnyObject]?) -> [Question] {
        var questionList: [Question] = []
        if let data = jsonDictionary {
            guard let questionsArray = data["questions"] as? [[String: AnyObject]] else {
                return []
            }
            
            for question in questionsArray {
                switch(questionCategory) {
                case .Booking:
                    if let questionType = question["question_entity_id"] as? String {
                        if Int(questionType) == QuesTionType.Booking.rawValue {
                           
                            let questionID = Int((question["question_id"] as? String)!)
                            let questionName = (question["question_name"] as? String)!
                            let isMultipart = (question["is_multiple"] as? String)! == "yes" ? true : false
                            questionList.append(Question(questionID: questionID!, questionName: questionName, isMultipart: isMultipart))
                        }
                    }
                    break
                    
                case .Social:
                    if let questionType = question["question_entity_id"] as? String {
                        if Int(questionType) == QuesTionType.Social.rawValue {
                            let questionID = Int((question["question_id"] as? String)!)
                            let questionName = (question["question_name"] as? String)!
                            let isMultipart = (question["is_multiple"] as? String)! == "yes" ? true : false
                            questionList.append(Question(questionID: questionID!, questionName: questionName, isMultipart: isMultipart))
                        }
                    }
                    break
                }
            }
        }
        return questionList
    }
    
    static func getListOfEventsOne(jsonDictionary: [String: AnyObject]?, completionHandler: [Event] -> ()) {
        if jsonDictionary != nil {
            if let eventsDictionaryList = jsonDictionary!["events"] as? [[String: AnyObject]] {
                var eventList: [Event] = []
                for individualEventDictionary in eventsDictionaryList {
                    eventList.append(Event(data: individualEventDictionary))
                }
                completionHandler(eventList)
            }
        }
    }
    
    static func getVenueObject(jsonDictionary: [String: AnyObject], completion: Venue -> ()){
        if let venueDictionary = jsonDictionary["venue"] as? [String: AnyObject] {
            completion(Venue(data: venueDictionary))
        }
    }
    
    static func getCurrentReservationList(data: [String: AnyObject]) -> [MemberReservation]? {
        var reservationArray: [MemberReservation] = []
        if let reservations = data["reservations"] as? [[String: AnyObject]] {
            for reservation in reservations {
                reservationArray.append(MemberReservation(data: reservation))
            }
            return reservationArray
        }
        return nil
    }
}
