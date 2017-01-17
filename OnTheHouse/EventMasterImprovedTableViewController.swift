//
//  EventMasterImprovedTableViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 9/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//


import UIKit

class EventMasterImprovedTableViewController: UITableViewController {
    
    var progressIndicator: UIActivityIndicatorView?
    var eventsList: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProgressIndicator()
        tableView.registerNib(UINib(nibName: "EventDetailCustomViewCell", bundle: nil), forCellReuseIdentifier: "eventMasterCell")
        tableView.estimatedRowHeight = 44.0
        tableView.separatorStyle = .None
        OTHService.sharedInstance.getDataFromOTH("events/current") { (dictionary) in
            self.eventsList = DataFormatter.getListOfEvents(dictionary).filter({ $0.isCompetition == false })
            self.progressIndicator?.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func configureProgressIndicator() {
        progressIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        progressIndicator?.color = UIColor.blackColor()
        progressIndicator?.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        progressIndicator?.center = self.view.center
        progressIndicator?.hidesWhenStopped = true
        view.addSubview(progressIndicator!)
        progressIndicator?.bringSubviewToFront(view)
        progressIndicator?.startAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eventsList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventMasterCell", forIndexPath: indexPath) as! MasterDetailTableViewCell
        let event = self.eventsList[indexPath.row]
        
        cell.FullPrice.text = event.priceRange
        //cell.EventHeadingPrice.text = "Admin Fee $10"
        cell.EventHeadingPrice.text = event.eventPirceHeadingAndPrice
        cell.EventTitle.text = event.name
        cell.eventImage.layer.cornerRadius = 8
        cell.eventImage.clipsToBounds = true
        cell.eventImage.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.eventImage.layer.borderWidth = 4
        cell.eventImage.image = event.thumbNailImage
        cell.BronzeImage.hidden = event.bronzeLogoVisibility
        cell.GoldImage.hidden = event.goldLogoVisibility
        cell.selectionStyle = .None
        return cell
    }
    // MARK: - Navigation
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        print("segueing")
        self.performSegueWithIdentifier("showDetails", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let  destinationController =  segue.destinationViewController  as? ImprovedEventDetailViewController {
                    print("setting id")
                    destinationController.eventId = self.eventsList[indexPath.row].id!
                }
            }
        }
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        var params: [String: AnyObject] = ["date": "range",
                                           "date_from": "2016-08-25",
                                           "date_to": "2016-08-25"
        ]
        
        if segue.identifier == "unwindSegue" {
            if let sourceViewController = segue.sourceViewController as? FilterEventsTableViewController  {
                
                guard let selectedCategories = sourceViewController.categoryParams, selectedZones = sourceViewController.stateParams, categoryList = sourceViewController.categoryList, statesList = sourceViewController.stateList else {
                    return
                }
                print(selectedCategories)
                print(selectedZones)
                print(categoryList)
                print(statesList)
                
                print("***********")
                
                var searchCategoryParameters: [Int] = []
                var searchZoneParameters: [Int] = []
                
                for selectedCategory in selectedCategories {
                    searchCategoryParameters.append(categoryList[selectedCategory].id)
                }
                
                for selectedZone in selectedZones {
                    searchZoneParameters.append(statesList[selectedZone].id)
                }
                
                print("Category search")
                print(searchCategoryParameters)
                print("*********************")
                print("Zone search")
                print(searchZoneParameters)
                
                params["category_id"] = searchCategoryParameters
                params["zone_id"] = searchZoneParameters
                print("*********************")
                print(params)
                
            }
        }


        OTHService.sharedInstance.postDataToOTHJSON("events/current", parameters: params) { (dictionary) in
            self.eventsList = DataFormatter.getListOfEvents(dictionary)
            print(self.eventsList.count)
            self.tableView.reloadData()
        }
    }
    
     @IBAction func unwindToEventMaster(segue: UIStoryboardSegue) {
    }
    
}
