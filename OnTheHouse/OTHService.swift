//
//  OTHService.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 13/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import Alamofire

class OTHService {
    
    static let sharedInstance = OTHService()
    
    var url: String = ""
    
    private init() {
        url = Constants.OTH.ApiBaseUrl
    }
    
    func getDataFromOTH(subUrl: String = "", completionHandler: [String: AnyObject] -> ()) {
        
        Alamofire.request(.GET, self.url+"/\(subUrl)", headers: OTHAuthentication.fetchAuthenticationHeader).response { (request, response, data, error) in
            if error == nil {
                if let OTHData = data {
                    do {
                        var parsedResult: [String: AnyObject] = [:]
                        parsedResult = try NSJSONSerialization.JSONObjectWithData(OTHData, options: .AllowFragments) as! [String: AnyObject]
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(parsedResult)
                        })
                    } catch {
                        print("Problem in converting JSON into NSData")
                    }
                }
            } else {
                print(error?.description)
            }
        }
    }
    
    // url contains the eventid and parameter is memberid
    func postDataToOTH(subUrl: String, parameters: [String: AnyObject], completionHandler: [String: AnyObject] -> ()) {
    
        Alamofire.request(.POST, self.url+"/\(subUrl)", parameters: parameters, headers: OTHAuthentication.fetchAuthenticationHeader).response { (request, response, data, error) in
            if error == nil {
                if let myData = data {
                    let parsedResult: [String: AnyObject]
                    do {
                        parsedResult = try NSJSONSerialization.JSONObjectWithData(myData, options: .AllowFragments) as! [String: AnyObject]
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(parsedResult)
                        })
                    } catch {
                        print("Could not parse the data as JSON: '\(data)'")
                        return
                    }
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    /*
    func postDataToOTHNew(subUrl: String, params: [String: AnyObject], completionHandler: [String: AnyObject] -> ()) {
        print("Starting")
        do {
            let json = try NSJSONSerialization.dataWithJSONObject(params, options: [])
            let url = NSURL(string: self.url+"/\(subUrl)")
            if let url = url {
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.HTTPBody = json
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: config)
                
                
                 let userName = "Yv8dz4sD"
                 let password = "zeqA7\\NVxLAujn"
                 let PasswordString = "\(userName):\(password)"
                 let PasswordData = PasswordString.dataUsingEncoding(NSUTF8StringEncoding)
                 let base64EncodedCredential = PasswordData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
 
                 let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                 let authString = "Basic \(base64EncodedCredential)"
                 config.HTTPAdditionalHeaders = ["Authorization" : authString]
                 let session = NSURLSession(configuration: config)
 
 
                session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
                    if error == nil {
                        if let myData = data {
                            let parsedResult: [String: AnyObject]
                            do {
                                parsedResult = try NSJSONSerialization.JSONObjectWithData(myData, options: .AllowFragments) as! [String: AnyObject]
                                dispatch_async(dispatch_get_main_queue(), {
                                    completionHandler(parsedResult)
                                })
                            } catch {
                                print("Could not parse the data as JSON: '\(data)'")
                                return
                            }
                        }
                    } else {
                        print(error?.localizedDescription)
                    }
                }).resume()
            } else {
                print("cant construct URL")
            }
        } catch {
            print("Data cant be converted into JSON")
        }
    } */
    
    func postDataToOTHJSON(subUrl: String, parameters: [String: AnyObject], completionHandler: [String: AnyObject] -> ()) {
        
        Alamofire.request(.POST, self.url+"/\(subUrl)", parameters: parameters, headers:  OTHAuthentication.fetchAuthenticationHeader, encoding: .JSON).response { (request, response, data, error) in
            print("******")
            print(NSString(data: (request?.HTTPBody)!, encoding: NSUTF8StringEncoding))
            print("******")
            if error == nil {
                if let myData = data {
                    let parsedResult: [String: AnyObject]
                    do {
                        parsedResult = try NSJSONSerialization.JSONObjectWithData(myData, options: .AllowFragments) as! [String: AnyObject]
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(parsedResult)
                        })
                    } catch {
                        print("Could not parse the data as JSON: '\(data)'")
                        return
                    }
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
}
