//
//  OTHAuthentication.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 9/11/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation

struct OTHAuthentication {
    static var fetchAuthenticationHeader: [String: String] {
        let username = Constants.OTH.userName
        let password = Constants.OTH.password
        let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        return ["Authorization": "Basic \(base64Credentials)"]
    }
}