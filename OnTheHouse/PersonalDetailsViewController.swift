//
//  PersonalDetailsViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 5/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Eureka
class PersonalDetailsViewController: FormViewController {
    
    var dataService: OTHService?
    var languageList: [Language] = []
    var  personalDetails: [String: AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        self.dataService = OTHService.sharedInstance
        
        form
            +++ Section()
            <<< TextRow(){ row in
                row.title = "Nickname"
                row.value = NSUserDefaults.standardUserDefaults().stringForKey("nickName")
                personalDetails["nickname"] = row.value
                row.placeholder = row.value
            }
            
            <<< AlertRow<String>(){ row in
                row.title = "Title"
                row.tag = "title"
                row.value = NSUserDefaults.standardUserDefaults().stringForKey("title")
                personalDetails["title"] = row.value
                dataService?.getDataFromOTH("member/titles", completionHandler: { (dictionary) in
                    row.options =  DataFormatter.getListOfString(dictionary)
                })
            }
            
            <<< TextRow(){ row in
                row.title = "First Name"
                row.value = NSUserDefaults.standardUserDefaults().stringForKey("firstName")
                personalDetails["first_name"] = row.value
                row.placeholder = row.value
                row.tag = "firstName"
            }
            
            <<< TextRow(){ row in
                row.title = "Last Name"
                row.value = NSUserDefaults.standardUserDefaults().stringForKey("lastName")
                personalDetails["last_name"] = row.value
                row.placeholder = row.value
                row.tag = "lastName"
            }
            <<< EmailRow(){ row in
                row.title = "Email"
                row.value = NSUserDefaults.standardUserDefaults().stringForKey("email")
                personalDetails["email"] = row.value
                row.placeholder = row.value
                row.tag = "email"
            }
            
            <<< AlertRow<String>(){ row in
                row.title = "Age Group"
                row.tag = "ageGroup"
                row.value = NSUserDefaults.standardUserDefaults().stringForKey("ageGroup")
                personalDetails["age"] = row.value
                dataService?.getDataFromOTH("member/ages", completionHandler: { (dictionary) in
                    row.options =  DataFormatter.getListOfMemberAges(dictionary)
                })
            }
            
            <<< PhoneRow(){ row in
                row.title = "PhoneNumber"
                row.value = NSUserDefaults.standardUserDefaults().stringForKey("phone")
                row.placeholder = row.value
                personalDetails["phone"] = row.value
                row.tag = "phoneNumber"
            }
            
            +++ Section("Your saved languages")
            <<< TextAreaRow("yourlanguages") {
                $0.title = "Your Languages"
                //$0.placeholder = "Notes"
                $0.textAreaHeight = .Dynamic(initialTextViewHeight: 80)
            }
            
            <<< MultipleSelectorRow<String>("language", { (row) in
                row.title = "Select Language"
                row.options = []
                //row.value = ["a", "b", "c"] // defaults
                dataService?.getDataFromOTH("languages", completionHandler: { (dictionary) in
                    self.languageList = DataFormatter.getListOfLanguages(dictionary)
                    for language in self.languageList {
                        row.options.append(language.name)
                    }
                    let textArea = self.form.rowByTag("yourlanguages") as? TextAreaRow
                    if let savedLanguageValues = NSUserDefaults.standardUserDefaults().objectForKey("languages") as? [Int] {
                        print("***** inside *******")
                        print(savedLanguageValues)
                        print(self.extractNamesFromSavedLanguageList(savedLanguageValues))
                        textArea?.value = self.extractNamesFromSavedLanguageList(savedLanguageValues)
                        // At this stage pick up the saved category list from ns user defaults and cast it to a integer array using splitedString.map({ Int($0)! }) and then pass that value to the function to get a string of categories
                        textArea?.updateCell()
                    }
                })
            }).onPresent({ (from, to) in
                to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: from, action: #selector(PersonalDetailsViewController.multipleSelectorDone(_:)))
            })
            +++ Section("Your current selection")
            <<< TextAreaRow("currentSelectionLanguage") {
                //$0.placeholder = "Notes"
                $0.textAreaHeight = .Dynamic(initialTextViewHeight: 200)
        }
    }
    
    
    // Do any additional setup after loading the view.
    
    
    
    
    func extractNamesFromSavedLanguageList(userLangaugeList: [Int]) -> String {
        var selectedLanguages = ""
        for outerIndex in 0..<userLangaugeList.count {
            for innerIndex in 0..<self.languageList.count {
                if self.languageList[innerIndex].id == userLangaugeList[outerIndex] {
                    if outerIndex != userLangaugeList.count - 1 {
                        selectedLanguages += self.languageList[innerIndex].name + " - "
                    } else {
                        selectedLanguages += self.languageList[innerIndex].name
                    }
                }
            }
        }
        print(selectedLanguages)
        return selectedLanguages
    }
    
    func multipleSelectorDone(item: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
        //print(form.values(includeHidden: true))
        let values = form.values()
        if let languageSet = values["language"] as? NSSet {
            if let languageArray = languageSet.allObjects as? [String] {
                print("*********** Language Ids***********************")
                print(extractLanguageIdFromLanguageObjectArray(languageArray))
                if !languageArray.isEmpty {
                    var textAreaString = ""
                    for i in 0..<languageArray.count {
                        if i != languageArray.count - 1 {
                            textAreaString += languageArray[i] + "\n"
                        } else {
                            textAreaString += languageArray[i]
                        }
                    }
                    let textArea = self.form.rowByTag("currentSelectionLanguage") as? TextAreaRow
                    textArea?.value = textAreaString
                    textArea?.updateCell()
                }
            }
        }
    }
    
    func extractLanguageIdFromLanguageObjectArray(value: [String]) -> [Int] {
        var finalList: [Int] = []
        for outerIndex in 0..<value.count {
            for innerIndex in 0..<self.languageList.count {
                if self.languageList[innerIndex].name == value[outerIndex] {
                    finalList.append(self.languageList[innerIndex].id)
                }
            }
        }
        return finalList
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Make the change
    
    
    @IBAction func doneAction(sender: AnyObject) {
        print("inside method")
        let valuesDictionary = form.values()
        
        
        if let nickname = valuesDictionary["nickname"] as? String {
            personalDetails["nickname"] = nickname
            print(personalDetails["nickname"])
        }
        
        if let title = valuesDictionary["title"] as? String{
            personalDetails["title"] = title
        }
        
        if let firstName = valuesDictionary["firstName"] as? String{
            personalDetails["first_name"] = firstName
        }
        
        if let lastName = valuesDictionary["lastName"] as? String{
            personalDetails["last_name"] = lastName
        }
        
        if let phone = valuesDictionary["phoneNumber"] as? String{
            personalDetails["phone"] = phone
        }
        
        if let email = valuesDictionary["email"] as? String{
            personalDetails["email"] = email
        }
        
        if let age = valuesDictionary["ageGroup"] as? String{
            personalDetails["age"] = age
        }
        
        if let languageSet = valuesDictionary["language"] as? NSSet {
            if let languageArray = languageSet.allObjects as? [String] {
                print("*********** Language Ids***********************")
                
                let selectedLangauges = extractLanguageIdFromLanguageObjectArray(languageArray)
                print("user selected")
                print(selectedLangauges)
                personalDetails["language_id"] = selectedLangauges
            }
            
        } else {
            if let savedLanguageValues = NSUserDefaults.standardUserDefaults().objectForKey("languages") as? [Int] {
                personalDetails["language_id"] = savedLanguageValues
            }
        }
        
        print(personalDetails)
        
        
        let userID = NSUserDefaults.standardUserDefaults().integerForKey("id")
        self.dataService!.postDataToOTH("memberpersonaldetails/\(userID)",parameters: personalDetails,completionHandler: { (dictionary) in
            if !APIStatus.isSuccessfulResponse(dictionary) {
                if let list = APIStatus.retrieveErrorMessage(dictionary) {
                    if let alert = APIStatus.showAlertMessageToUser(list) {
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            } else {
                Member(data: (dictionary["member"] as? [String: AnyObject])!)
                print("data from server")
                print(dictionary)
                self.performSegueWithIdentifier("unwindPersonalDetails", sender: nil)
            }
        })
        
    }
}
