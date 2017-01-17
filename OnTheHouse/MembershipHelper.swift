//
//  MembershipHelper.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 7/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
class MembershipHelper {
    
    static func sendGoldMembershipConfirmationToOTH(params: [String: AnyObject], completion: (Bool) -> ()) {
        print("starting call")
        
        OTHService.sharedInstance.postDataToOTH("member/membership/update", parameters: params, completionHandler: { (dictionary) in
            print(dictionary)
            
            guard let status = dictionary["status"] as? String else {
                return
            }
            completion(status == "success" ? true : false)
        })
    }
}

