//
//  FilterEventsTableViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 22/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class FilterEventsTableViewController: UITableViewController {
    
    var section: [String]?
    var items: [[String]]?
    var stateList: [State]?
    var categoryList: [Category]?
    var stateParams: [Int]?
    var categoryParams: [Int]?
    var selectedRowsForCategory: [Bool] = []
    var selectedRowsForState: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "CustomStateCell", bundle: nil), forCellReuseIdentifier: "state")
        self.tableView.allowsMultipleSelection = true
    
        categoryList = []
        stateList = []
        self.section = ["Category", "State"]
        categoryParams = []
        stateParams = []
        selectedRowsForCategory = []

        OTHService.sharedInstance.getDataFromOTH("categories") { (dictionary) in
            self.categoryList = DataFormatter.getListOfCategories(dictionary)
            for _ in 0..<self.categoryList!.count {
                self.selectedRowsForCategory.append(false)
            }
            self.tableView.reloadData()
        }

        OTHService.sharedInstance.getDataFromOTH("zones/\(13)") { (dictionary) in
            self.stateList = DataFormatter.getListOfStates(dictionary)
            for _ in 0..<self.stateList!.count {
                self.selectedRowsForState.append(false)
            }
            self.tableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.section!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section![section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return categoryList!.count
        } else if section == 1 {
            return stateList!.count
        }
        return 0
    }    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // category
            let cell  = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel!.text = self.categoryList![indexPath.row].name
            if selectedRowsForCategory[indexPath.row] {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            return cell
        } else {
            // state
            let cell  = tableView.dequeueReusableCellWithIdentifier("state", forIndexPath: indexPath) as? StateTableViewCell
            cell!.stateLabel.text = self.stateList![indexPath.row].name
            if selectedRowsForState[indexPath.row] {
                cell!.accessoryType = .Checkmark
            } else {
                cell!.accessoryType = .None
            }
            return cell!
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        
        if indexPath.section == 0 {
            categoryParams!.append(indexPath.row)
            selectedRowsForCategory[indexPath.row] = !selectedRowsForCategory[indexPath.row]
        } else {
            stateParams!.append(indexPath.row)
            selectedRowsForState[indexPath.row] = !selectedRowsForState[indexPath.row]
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .None
        if indexPath.section == 0 {
            selectedRowsForCategory[indexPath.row] = !selectedRowsForCategory[indexPath.row]
            self.categoryParams = categoryParams!.filter{ $0 != indexPath.row }
        } else {
            selectedRowsForState[indexPath.row] = !selectedRowsForState[indexPath.row]
            self.stateParams = stateParams!.filter{ $0 != indexPath.row }
        }
    }
    
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction private func backToPreviousPage() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func sendParametersToMaster(sender: UIBarButtonItem) {
        print(stateList)
        print(categoryList)
        self.performSegueWithIdentifier("unwindSegue", sender: self)
    }
}