//
//  ImprovedEventFilterViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 22/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Eureka

class ImprovedEventFilterViewController: FormViewController {
    
    var categoryList: [Category] = []
    var statesList: [State] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        DateRow.defaultRowInitializer = { row in row.minimumDate = NSDate() }
        form
            +++ Section("Date")
            <<< DateRow() { row in
                row.title = "Event Starting from"
                row.tag = "start_date"
                row.value = NSDate()
                }.onChange({ (row) in
                    let endDateRow = self.form.rowByTag("end_date") as! DateRow
                    endDateRow.value = NSDate(timeInterval: 24*60*60, sinceDate: row.value!)
                    endDateRow.updateCell()
                })
            
            <<< DateRow() { row in
                row.title = "Event Ending on"
                row.tag = "end_date"
                row.value = NSDate(timeInterval: 24*60*60, sinceDate: NSDate())
            }.onChange({ (row) in
                let startDateRow = self.form.rowByTag("start_date") as! DateRow
                if let startDate = startDateRow.value {
                    if ((row.value?.isEqualToDate(startDate)) == true) {
                        print("Dates equal")
                        row.value = NSDate(timeInterval: 24*60*60, sinceDate: startDate)
                    }
                    else if ((row.value?.isLessThanDate(startDate)) == true) {
                        print("End Date less")
                        row.value = NSDate(timeInterval: 24*60*60, sinceDate: startDate)
                    }
                }
            })
            +++ Section("Category")
            <<< MultipleSelectorRow<String> { row in
                row.title = "Category"
                row.tag = row.title?.lowercaseString
                row.options = []
                OTHService.sharedInstance.getDataFromOTH("categories", completionHandler: { (dictionary) in
                    self.categoryList = DataFormatter.getListOfCategories(dictionary)
                    for category in self.categoryList {
                        row.options.append(category.name)
                    }
                })
            }.onPresent({ (form, multipleSelectorViewController) in
                multipleSelectorViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: form, action: #selector(ImprovedEventFilterViewController.doneActionOnCategoryList(_:)))
            })
            +++ Section("State")
            <<< MultipleSelectorRow<String> { row in
                row.title = "State"
                row.tag = row.title?.lowercaseString
                row.options = []
                OTHService.sharedInstance.getDataFromOTH("zones/13", completionHandler: { (dictionary) in
                    self.statesList = DataFormatter.getListOfStates(dictionary)
                    for state in self.statesList {
                        row.options.append(state.name)
                    }
                })
            }.onPresent({ (form, multipleSelectorViewController) in
                multipleSelectorViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: form, action: #selector(ImprovedEventFilterViewController.statesDoneAction))
            })
        
        // Do any additional setup after loading the view.
    }
    
    func doneActionOnCategoryList(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
        let values = form.values()
        print(values["category"])
    }
    
    func statesDoneAction(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
        let values = form.values()
        print(values["state"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
     func extractCategoryIDFromCategoryList(categories: [String]) -> [Int] {
     var categoryIDList: [Int] = []
     for outerIndex in 0..<categories.count {
     for innerIndex in 0..<self.categoryList.count {
     if categoryList[innerIndex].name == categories[outerIndex] {
     categoryIDList.append(categoryList[innerIndex].id)
     }
     }
     }
     return categoryIDList
     }
     
     func extractStateIDFromStatesList(states: [String]) -> [Int] {
     var statesIDList: [Int] = []
     for outerIndex in 0..<states.count {
     for innerIndex in 0..<self.statesList.count {
     if self.statesList[innerIndex].name = states[outerIndex] {
     statesIDList.append(self.statesList[innerIndex].id)
     }
     }
     let value = self.statesList.filter { $0.name == states[outerIndex] }.id
     }
     return statesIDList
     }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
