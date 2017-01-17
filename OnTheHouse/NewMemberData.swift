//
//  NewMemberData.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 14/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
struct NewMemberData {
    static var nickName: String = ""
    static var firstName: String = ""
    static var lastName: String = ""
    static var zip: String = ""
    static var zoneID: String = ""
    static var countryID: String = "13"
    static var timezoneID: String = ""
    static var questionID: String =  "1"
    static var questionText:String = ""
    static var email: String = ""
    static var password: String = ""
    static var passwordConfirm: String = ""
    static var terms: String = "1"
    
    static func getParameters() -> [String: String] {
        return ["nickname": nickName,
        "first_name": firstName,
        "last_name": lastName,
        "zip": zip,
        "zone_id": zoneID,
        "country_id": countryID,
        "timezone_id": timezoneID,
        "question_id": questionID,
        "question_text": questionText,
        "email": email,
        "password": password,
        "password_confirm": passwordConfirm,
        "terms": "1"]
    }
}