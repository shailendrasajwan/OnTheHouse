//
//  TrialViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 3/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//



import UIKit
import Eureka


class AddressViewController: FormViewController {
    var countryList: [Country] = []
    var statesList: [State] = []
    var timeZonesList: [TimeZone] = []
    var dataService: OTHService?
    var  addressDetails: [String:String] = [:]
    var  timezoneDetails: [String:Int] = [:]
    var  stateDetails: [String:Int] = [:]
    var  countryId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataService = OTHService.sharedInstance
        form
            +++ Section()
            <<< TextRow(){ row in
                row.title = "Street"
                var addressString = ""
                if let addressLineOne = NSUserDefaults.standardUserDefaults().objectForKey("address1") as? String {
                    addressString += addressLineOne
                }
                
                if let addressLineTwo = NSUserDefaults.standardUserDefaults().objectForKey("address2") as? String {
                    addressString += addressLineTwo
                }
                
                row.value = addressString
                row.placeholder = row.value
                addressDetails["address1"] = row.value
                row.tag = "street"
            }
            
            <<< TextRow(){ row in
                row.title = "City"
                if let city = NSUserDefaults.standardUserDefaults().objectForKey("city") as? String {
                    
                    row.value = city
                    row.placeholder = row.value
                    addressDetails["city"] = row.value
                    
                }
                row.tag = "city"
            }
            
            <<< PhoneRow() {  row in
                row.title = "Post Code"
                //   String(NSUserDefaults.standardUserDefaults().integerForKey("zip"))
                if let zip: String  = String(NSUserDefaults.standardUserDefaults().integerForKey("zip")){
                    row.value = zip
                    row.placeholder = row.value
                    addressDetails["zip"] = row.value
                }
                
                
                row.tag = "postCode"
            }
            
            //(GMT+10:00) Melbourne
            +++ Section("Select Time Zone")
            <<< PickerRow<String>("timeZone") { (row : PickerRow<String>) -> Void in
                OTHService.sharedInstance.getDataFromOTH("timezones", completionHandler: { (dictionary) in
                    row.options = []
                    row.tag = "timeZone"
                    self.timeZonesList = DataFormatter.getTimeZones(dictionary)
                    row.options = []
                    for timeZone in self.timeZonesList {
                        row.options.append(timeZone.name)
                        
                        self.timezoneDetails[timeZone.name] = timeZone.id
                        //  print("inside timezones loop")
                        //  print((self.timezoneDetails[timeZone.name])!)
                        //print(row.options)
                    }
                    let userTimeZone: Int = NSUserDefaults.standardUserDefaults().integerForKey("timezone")
                    // print("timezone")
                    // print(userTimeZone)
                    let timeZoneIndex = self.extractIndexFromtimeZones(userTimeZone)
                    // print("Timezone \(timeZoneIndex)")
                    row.value = row.value ?? row.options[timeZoneIndex!]
                    self.timezoneDetails[row.value!] = userTimeZone
                    //print("default index")
                    // print((self.timezoneDetails[row.value!])!)
                    self.addressDetails["timezone_id"] = String(userTimeZone)
                    row.reload()
                })
                }.onChange({ (row) in
                    if let country = row.value {
                        if let id: Int = self.extractIndexFromTimeZoneName(country) {
                            print("myid")
                            print(id)
                            self.addressDetails["timezone_id"] = String(id)
                            
                            if let timeZoneRow = self.form.rowByTag("timezone") as? PickerRow<String> {
                                OTHService.sharedInstance.getDataFromOTH("timezones", completionHandler: { (dictionary) in
                                    self.timeZonesList = DataFormatter.getTimeZones(dictionary)
                                    timeZoneRow.options = []
                                    for timeZone in self.timeZonesList {
                                        timeZoneRow.options.append(timeZone.name)
                                        self.timezoneDetails[timeZone.name] = timeZone.id
                                        
                                    }
                                    timeZoneRow.updateCell()
                                })
                            }
                        } else {
                            print("Not found")
                        }
                    }
                })
            
            
            
            +++ Section("Select Country")
            <<< PickerRow<String>("country") { (row : PickerRow<String>) -> Void in
                OTHService.sharedInstance.getDataFromOTH("countries") { (dictionary) in
                    //print(DataFormatter.getListOfCountriesEnhanced(dictionary).count)
                    self.countryList = DataFormatter.getListOfCountriesEnhanced(dictionary)
                    row.options = []
                    for country in self.countryList {
                        row.options.append(country.name)
                        
                    }
                    row.tag = "country"
                    let countryIndex = NSUserDefaults.standardUserDefaults().integerForKey("country")
                    let countryPosition = self.extractIndexFromCountryList(countryIndex)
                    row.value = row.value ?? row.options[countryPosition!]
                    self.addressDetails["country_id"] = String(countryIndex)
                    
                    row.reload()
                }
                }.onChange({ (row) in
                    if let country = row.value {
                        if let id: Int = self.extractCountryIDFromCountryName(country) {
                            print(id)
                            //self.countryId = String(id)
                            print(self.countryId)
                            self.addressDetails["country_id"] =  String(id)
                            if let stateRow = self.form.rowByTag("state") as? PickerRow<String> {
                                OTHService.sharedInstance.getDataFromOTH("zones/\(id)", completionHandler: { (dictionary) in
                                    self.statesList = DataFormatter.getListOfStates(dictionary)
                                    stateRow.options = []
                                    for state in self.statesList {
                                        stateRow.options.append(state.name)
                                        //self.stateDetails[state.name] = state.id
                                        
                                    }
                                    stateRow.updateCell()
                                })
                            }
                        } else {
                            print("Not found")
                        }
                    }
                })
            
            +++ Section("Select State")
            <<< PickerRow<String>("state") { (row : PickerRow<String>) -> Void in
                OTHService.sharedInstance.getDataFromOTH("zones/countryId") { (dictionary) in
                    self.statesList = DataFormatter.getListOfStates(dictionary)
                    // print("state dictionary")
                    // print(dictionary)
                    row.options = []
                    row.tag = "state"
                    for state in self.statesList {
                        row.options.append(state.name)
                        print(state.name)
                        self.stateDetails[state.name] = state.id
                    }
                    let userStateID = NSUserDefaults.standardUserDefaults().integerForKey("state")
                    let stateIndex = self.extractIndexFromStateName(userStateID)
                    
                    print("state Index \(stateIndex)")
                    row.value = row.value ?? row.options[stateIndex!]
                    self.addressDetails["zone_id"] = String(userStateID)
                    row.reload()
                }
        }
        
        
        /*.onChange({ (row) in
         if let stateName = row.value {
         if let stateid: Int = self.extractStateIdFromStateNames(stateName) {
         print("print state id")
         print(stateid)
         self.addressDetails["zone_id"] = String(stateid)
         }
         }
         })*/
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if let timeZoneRow = form.rowByTag("timeZone") as? PickerRow<String> {
            timeZoneRow.reload()
        }
        
        if let countryRow = form.rowByTag("country") as? PickerRow<String> {
            countryRow.reload()
        }
        
    }
    
    func extractCountryIDFromCountryName(name: String) -> Int? {
        for i in 0..<self.countryList.count {
            if self.countryList[i].name == name {
                return self.countryList[i].id
            }
        }
        return nil
    }
    
    func extractIndexFromStateName(stateId: Int) -> Int? {
        for i in 0..<self.statesList.count {
            print("state \( self.statesList[i].id)")
            if self.statesList[i].id == stateId {
                print("state \( self.statesList[i].id)")
                print(i)
                return i
            }
        }
        return nil
    }
    
    func extractStateIdFromStateName(name: String) -> Int? {
        for i in 0..<self.statesList.count {
            // print("state \( self.statesList[i].name)")
            if self.statesList[i].name == name {
                // print("state \( self.statesList[i].id)")
                // print(i)
                return self.statesList[i].id
            }
        }
        return nil
    }
    
    func extractStateIdFromStateNames(name: String) -> Int? {
        print((stateDetails[name])!)
        return (stateDetails[name])!
        
    }
    
    func extractIndexFromTimeZoneName(name: String) -> Int {
        print((timezoneDetails[name])!)
        return (timezoneDetails[name])!
    }
    
    func extractIndexFromtimeZones(timeZoneID: Int) -> Int? {
        for i in 0..<self.timeZonesList.count {
            print("TimeZonesloop \(timeZonesList[i].id)")
            if self.timeZonesList[i].id == timeZoneID {
                print("TimeZonesloop \(timeZonesList[i].id)")
                return i
            }
        }
        return nil
    }
    
    func extractIndexFromCountryList(countryID: Int) -> Int? {
        for i in 0..<self.countryList.count {
            if self.countryList[i].id == countryID {
                return i            }
        }
        return nil
    }
    
    func extractcountryIdFromCountryName(name: String) -> String? {
        for i in 0..<self.countryList.count {
            if self.countryList[i].name == name {
                return String(countryList[i].id)            }
        }
        return nil
    }
    
    func extractTimeZoneIdFromTimeZoneObjectArray(value: String) -> String {
        var  finalString = ""
        for i in 0..<timeZonesList.count {
            if(timeZonesList[i].name == value){
                finalString = String(timeZonesList[i].id)
                break;
            }
            
        }
        print(finalString)
        return finalString
    }
    
    @IBAction func buttonDoneAction(sender: AnyObject) {
        
        print("inside method")
        let valuesDictionary = form.values()
        
        if let city = valuesDictionary["city"] as? String {
            addressDetails["city"] = city
            print(addressDetails["city"])
        }
        
        if let street = valuesDictionary["street"] as? String {
            addressDetails["address1"] = street
            print(addressDetails["address1"])
        }
        
        if let pincode = valuesDictionary["postCode"] as? String {
            addressDetails["zip"] = pincode
            print(addressDetails["zip"])
        }
        
        if let timeZoneSet = valuesDictionary["timeZone"] as? String{
            print(timeZoneSet)
            addressDetails["timezone_id"] = timeZoneSet
            let timezoneId: String  = extractTimeZoneIdFromTimeZoneObjectArray(timeZoneSet)
            addressDetails["timezone_id"] = timezoneId
            
        } else {
            var preExistingSelection = ""
            if let savedtimezone = NSUserDefaults.standardUserDefaults().objectForKey("timezone") as? String {
                print(savedtimezone)
                preExistingSelection  = extractTimeZoneIdFromTimeZoneObjectArray(savedtimezone)
                
                addressDetails["timezone_id"] = preExistingSelection
                print(preExistingSelection)
            }
        }
        
        if let countrySet = valuesDictionary["country"] as? String{
            print(countrySet)
            addressDetails["country_id"] = countrySet
            let countryId: String  = extractcountryIdFromCountryName(countrySet)!
            addressDetails["country_id"] = countryId
            print(countryId)
        }
        else {
            var preExistingSelection = ""
            if let savedCountry = NSUserDefaults.standardUserDefaults().objectForKey("country") as? String {
                print(savedCountry)
                preExistingSelection  = String(extractcountryIdFromCountryName(savedCountry))
                
                addressDetails["country_id"] = preExistingSelection
                print(preExistingSelection)
            }
        }
        
        if let stateSet = valuesDictionary["state"] as? String{
            print(stateSet)
            let stateId  = String(extractStateIdFromStateName(stateSet))
            addressDetails["zone_id"] = stateId
            print(stateId)
        } else {
            var preExistingSelection1 = ""
            if let savedState = NSUserDefaults.standardUserDefaults().objectForKey("state") as? String {
                print(savedState)
                preExistingSelection1  = String(extractStateIdFromStateName(savedState))
                
                addressDetails["zone_id"] = preExistingSelection1
                print(preExistingSelection1)
                
                print("done action complete")
            }
        }
        
        let userID = NSUserDefaults.standardUserDefaults().integerForKey("id")
        print("done action complete")
        self.dataService!.postDataToOTH("memberaddress/\(userID)",parameters:addressDetails,completionHandler: { (dictionary) in
            if !APIStatus.isSuccessfulResponse(dictionary) {
                if let list = APIStatus.retrieveErrorMessage(dictionary) {
                    print(list)
                    if let alert = APIStatus.showAlertMessageToUser(list) {
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            } else {
                Member(data: (dictionary["member"] as? [String: AnyObject])!)
                print(dictionary)
                self.performSegueWithIdentifier("unwindAddressDetails", sender: nil)
            }
        })
    }
}