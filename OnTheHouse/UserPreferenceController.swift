//
//
//  TestViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 3/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Eureka

class UserPreferenceController: FormViewController {
    
    var categoryList: [Category] = []
    var preferenceDetails: [String: AnyObject] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpForm()
    }
    
    func  convertBooleanValue(value: Bool) -> String {
        return value == true ? String(1) : String(0)
    }
    
    func setUpForm() {
        CheckRow.defaultCellSetup = { cell, row in cell.textLabel!.font = UIFont(name: "Avenir", size: 12) }
        form
            +++ Section()
            <<< CheckRow("newsletter") {
                print("newsletter")
                print(NSUserDefaults.standardUserDefaults().boolForKey("newsLetters"))
                $0.title = "Unsubscribe from emails and periodicals"
                $0.value = NSUserDefaults.standardUserDefaults().boolForKey("newsLetters")
            }
            
            <<< CheckRow("focusgroup") {
                print("focusgroup")
                print(NSUserDefaults.standardUserDefaults().boolForKey("focusGroups"))
                $0.title = "Are you interested in participating in focus groups?"
                print("****print focus groups")
                print(NSUserDefaults.standardUserDefaults().boolForKey("focusGroups"))
                $0.value = NSUserDefaults.standardUserDefaults().boolForKey("focusGroups")
            }
            
            
            <<< CheckRow("paidmarketing") {
                print("paidmarketing")
                print($0.value = NSUserDefaults.standardUserDefaults().boolForKey("paidMarketing"))
                $0.title = "Are you interested in paid marketing work?"
                $0.value = NSUserDefaults.standardUserDefaults().boolForKey("paidMarketing")
            }
            
            
            +++ Section("Your saved categories")
            <<< TextAreaRow("yourCategories") {
                $0.title = "Your Categories"
                $0.textAreaHeight = .Dynamic(initialTextViewHeight: 80)
            }
            
            <<< MultipleSelectorRow<String>("category", { (row) in
                row.title = "Select Category"
                row.options = []
                row.tag = "category"
                OTHService.sharedInstance.getDataFromOTH("categories", completionHandler: { (dictionary) in
                    self.categoryList = DataFormatter.getListOfCategories(dictionary)
                    for category in self.categoryList {
                        row.options.append(category.name)
                    }
                })
            }).onPresent({ (form, to) in
                to.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: form, action: #selector(UserPreferenceController.multipleSelectorDone(_:)))
            })
            +++ Section("Your current selection")
            <<< TextAreaRow("notes") {
                $0.textAreaHeight = .Dynamic(initialTextViewHeight: 80)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let textArea = self.form.rowByTag("yourCategories") as? TextAreaRow
        if let savedCategoryValues = NSUserDefaults.standardUserDefaults().objectForKey("categories") as? [Int] {
            textArea?.placeholder = self.extractCategoryNameListFromCategoryIDList(savedCategoryValues)
            textArea?.updateCell()
        }
    }
    
    func multipleSelectorDone(item: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
        //print(form.values(includeHidden: true))
        let values = form.values()
        if let categorySet = values["category"] as? NSSet {
            if let categoryArray = categorySet.allObjects as? [String] {
                if !categoryArray.isEmpty {
                    var textAreaString = ""
                    for i in 0..<categoryArray.count {
                        if i != categoryArray.count - 1 {
                            textAreaString += categoryArray[i] + ","
                        } else {
                            textAreaString += categoryArray[i]
                        }
                    }
                    preferenceDetails["categories"] =  textAreaString
                    let textArea = self.form.rowByTag("notes") as? TextAreaRow
                    textArea?.placeholder = textAreaString
                    textArea?.updateCell()
                }
            }
        }
    }
    
    func extractCategoryNameListFromCategoryIDList(categoryIntegerList: [Int]) -> String {
        var selectedCategories = ""
        for outerIndex in 0..<categoryIntegerList.count {
            for innerIndex in 0..<self.categoryList.count {
                if self.categoryList[innerIndex].id == categoryIntegerList[outerIndex] {
                    if outerIndex != categoryIntegerList.count - 1 {
                        selectedCategories += self.categoryList[innerIndex].name + ","
                    } else {
                        selectedCategories += self.categoryList[innerIndex].name
                    }
                }
            }
        }
        return selectedCategories
    }
    
    func getCommaSeperatedCategoryID(categoryStringList: [String]) -> String {
        var selectedID = ""
        for outerIndex in 0..<categoryStringList.count {
            for innerIndex in 0..<self.categoryList.count {
                if self.categoryList[innerIndex].name == categoryStringList[outerIndex] {
                    if outerIndex != categoryStringList.count - 1 {
                        selectedID += "\(self.categoryList[innerIndex].id)" + ","
                    } else {
                        selectedID += "\(self.categoryList[innerIndex].id)"
                    }
                }
            }
        }
        return selectedID
    }
    
    func getSelectedCategoryIDList(categoryStringList: [String]) -> [Int] {
        var selectedID: [Int] = []
        for outerIndex in 0..<categoryStringList.count {
            for innerIndex in 0..<self.categoryList.count {
                if self.categoryList[innerIndex].name == categoryStringList[outerIndex] {
                    selectedID.append(self.categoryList[innerIndex].id)
                }
            }
        }
        return selectedID
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Make the change
    
    
    @IBAction func buttonAction(sender: AnyObject) {
        print("inside method")
        let doneButton = sender as? UIBarButtonItem
        doneButton?.enabled = false
        let valuesDictionary = form.values()
        print(valuesDictionary["category"])
        
        
        if let newsletter = valuesDictionary["newsletter"] as? Bool {
            let value = newsletter == true ? String(1) : String(0)
            preferenceDetails["newsletters"] = value
        }
        
        if let focusGroups = valuesDictionary["focusgroup"] as? Bool {
            let value = focusGroups == true ? String(1) : String(0)
            preferenceDetails["focus_groups"] = value
        }
        
        if let paidMarketing = valuesDictionary["paidmarketing"] as? Bool{
            let value = paidMarketing == true ? String(1) : String(0)
            preferenceDetails["paid_marketing"] = value
        }
        
        if let categoryStringValues = valuesDictionary["category"] as? NSSet {
            if let categoryStringArray = categoryStringValues.allObjects as? [String] {
                //preferenceDetails["categories"] = self.getCommaSeperatedCategoryID(categoryStringArray)
                preferenceDetails["categories"] = self.getSelectedCategoryIDList(categoryStringArray)
            }
        } else {
            if let savedCategoryValues = NSUserDefaults.standardUserDefaults().objectForKey("categories") as? [Int] {
                preferenceDetails["categories"] = savedCategoryValues
            }
        }
        
        print("user form")
        print(preferenceDetails)
        print("user form")
        
        
        print("start network call")
        let userID = NSUserDefaults.standardUserDefaults().integerForKey("id")
        OTHService.sharedInstance.postDataToOTH("memberpreferences/\(userID)",parameters: preferenceDetails, completionHandler: { (dictionary) in
            if !APIStatus.isSuccessfulResponse(dictionary) {
                doneButton?.enabled = true
                if let list = APIStatus.retrieveErrorMessage(dictionary) {
                    print(list)
                    
                    if let alert = APIStatus.showAlertMessageToUser(list) {
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            } else {
                doneButton?.enabled = true
                PreferenceData.dataParser((dictionary["member"] as? [String: AnyObject])!)
                self.performSegueWithIdentifier("unwindUserPreferences", sender: nil)
            }
        })
    }
}
 