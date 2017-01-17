//
//  MyMembershipViewController.swift
//  OnTheHouse
//
//  Created by Shailendra Singh Sajwan on 7/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Eureka
import Braintree

enum MemberShip: Int {
    
    case Bronze = 3
    case Gold = 9
    
    var levelID: Int {
        return self.rawValue
    }
}

class MyMembershipViewController: FormViewController, BTDropInViewControllerDelegate {
    
    var membershipdata: [Membership] = []
    var level: [MemberShipLevel] =   []
    var currentMemberShipLevel: Int?
    var currentSelection = 0
    var valueNewMembership  =  ""
    var selectedMembershipTag =  ""
    
    var membershipPrice: Float = 0.0
    var braintreeClient: BTAPIClient?
    private var  goldParams : [String: AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentMemberShipLevel = NSUserDefaults.standardUserDefaults().integerForKey("membership_level")
        print("Current member ship level")
        print(currentMemberShipLevel)
        
        braintreeClient = BTAPIClient(authorization: Constants.OTH.tokenizationKey)
        setUpForm()
    }
    
    func setUpForm() {
        
        var membershipLevel = [MemberShipLevel]()
        LabelRow.defaultCellUpdate = { cell, row in cell.detailTextLabel?.textColor = .blackColor()  }
        OTHService.sharedInstance.postDataToOTH("member/membership", parameters: ["member_id": String(NSUserDefaults.standardUserDefaults().integerForKey("id"))]) { (dictionary) in
            self.membershipdata =   DataFormatter.getMemberShipObject(dictionary)
            
            self.form
                +++ Section("Current Membership Details")
                
                <<< LabelRow() { row in
                    row.title = "Level"
                    row.value = self.membershipdata.first?.membershiplevelName
                }
                
                <<< LabelRow() { row in
                    row.title = "Period"
                    row.value =  (self.membershipdata.first?.membershipStartDate)! + " - " + (self.membershipdata.first?.membershipExpiryDate)!
                }
                
                <<< LabelRow() { row in
                    row.title = "You Paid"
                    row.value =  String((self.membershipdata.first?.price)!)
                }
                
                +++ SelectableSection<ImageCheckRow<String>, String>() { section in
                    section.header = HeaderFooterView(title: "My Membership?")
            }
            
            OTHService.sharedInstance.getDataFromOTH("membership_levels") { (dictionary) in
                print(DataFormatter.getListOfMemberShipLevels(dictionary).count)
                self.level = DataFormatter.getListOfMemberShipLevels(dictionary)
                
                for options in self.level {
                    membershipLevel.append(options)
                }
                for option in membershipLevel {
                    self.form.last! <<< ImageCheckRow<String>(option.name){ lrow in
                        lrow.title = option.name
                        if let levelFromName = self.extractMembershipLevelIdFromMemberShipName(option.name!) {
                            lrow.selectableValue = String(levelFromName) // extract member ship level id from member level object list, convert it to a string and bind it to the selectable value label
                            if let currentMemberShip = self.currentMemberShipLevel {
                                if currentMemberShip == levelFromName {
                                    print("Match- \(option.name)")
                                    lrow.value = String(currentMemberShip)
                                }
                            }
                        }
                        
                        }.onChange({ (row) in
                            print("value selected")
                            // print(row.selectableValue)
                            self.valueNewMembership = row.selectableValue!
                            print(self.valueNewMembership)
                            self.selectedMembershipTag = row.tag!
                            print(self.selectedMembershipTag)
                            // self.membershipPrice =
                            self.currentSelection = Int(row.selectableValue!)!
                        })
                }
            }
        }
        
    }
    
    override func rowValueHasBeenChanged(row: BaseRow, oldValue: Any?, newValue: Any?) {
        if row.section === form[0] {
            print("Single Selection:\((row.section as! SelectableSection<ImageCheckRow<String>, String>).selectedRow()?.baseValue)")
        }
    }
    
    func extractMembershipLevelIdFromMemberShipName(memberShipName: String) -> Int? {
        for individuallevel in self.level {
            if individuallevel.name == memberShipName {
                return individuallevel.id!
            }
        }
        return nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func userDidCancelPayment() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewController(viewController: BTDropInViewController,
                              didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce)
    {
        
        var finalNonce = ""
        
        if let payPalAccountNonce = paymentMethodNonce as? BTPayPalAccountNonce {
            finalNonce = payPalAccountNonce.nonce
        } else {
            finalNonce = paymentMethodNonce.nonce
        }
        
        print("nonce")
        print(finalNonce)
        
        goldParams["nonce"] = finalNonce
        print("***goldparams****")
        print(goldParams)
        
        MembershipHelper.sendGoldMembershipConfirmationToOTH(goldParams) { (result) in
            if result {
                print(result)
                var formMemberShipLevel = 0
                formMemberShipLevel = self.setMembershipLevel()
                NSUserDefaults().setInteger(formMemberShipLevel, forKey: "membership_level")
            }
            self.dismissViewControllerAnimated(true, completion: {
                self.presentViewController(self.showAlert(result), animated: true, completion: nil)
            })
        }
    }
    
    
    func getValueFromForm() -> [String: String] {
        var userDetails: [String: String] = [:]
        userDetails["member_id"] = String(NSUserDefaults.standardUserDefaults().integerForKey("id"))
        if let membershiplevel: Int = self.currentSelection {
            userDetails["membership_level_id"] = String(membershiplevel)
        }
        return userDetails
    }
    
    
    func configureBraintreePaymentRequest() -> BTPaymentRequest {
        print("payment request configuration")
        let membershipDetails = getValueFromForm()
        let paymentRequest = BTPaymentRequest()
        var paymentDescription = ""
        return paymentRequest
    }
    
    
    func setMembershipLevel()-> Int {
        let valuesDictionary = form.values()
        print(valuesDictionary)
        
        var formMemberShipLevel = 0
        
        if let userValue = valuesDictionary["Gold"] as? String {
            formMemberShipLevel = Int(userValue)!
        } else if let userValue1 = valuesDictionary["Bronze"] as? String {
            formMemberShipLevel = Int(userValue1)!
        }
        return  formMemberShipLevel
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        print("inside done")
        print(NSUserDefaults.standardUserDefaults().integerForKey("membership_level"))
        switch(NSUserDefaults.standardUserDefaults().integerForKey("membership_level")) {
        case MemberShip.Gold.levelID:
            let alertController = UIAlertController(title: "Change Membership Level", message: "Membership downgradation is yet to be completed.We will have to talk to Irena.", preferredStyle: .Alert)
            let OkAction = UIAlertAction(title: "OK", style: .Default) { (alertAction) in
                self.performSegueWithIdentifier("unwindFromMymembership", sender: nil)
            }
            alertController.addAction(OkAction)
            presentViewController(alertController, animated: true, completion: nil)
            break
        case MemberShip.Bronze.levelID:
            var formMemberShipLevel = 0
            formMemberShipLevel = self.setMembershipLevel()
            goldParams["membership_level_id"] = String(formMemberShipLevel)
            goldParams["member_id"] = String(NSUserDefaults.standardUserDefaults().integerForKey("id"))
            if(formMemberShipLevel == MemberShip.Gold.levelID && isUpgradable(NSUserDefaults.standardUserDefaults().integerForKey("membership_level"), selectedMemberShipLevel: formMemberShipLevel)) {
                print("done action gold")
                let dropInViewController = BTDropInViewController(APIClient: self.braintreeClient!)
                let paymentRequest = BTPaymentRequest()
                // this should not be hard coded
                
                paymentRequest.summaryTitle = "Gold"
                paymentRequest.amount =  "55.9"
                paymentRequest.summaryDescription = "Upgrade to Gold"
                paymentRequest.displayAmount = "$ 55.9"
                dropInViewController.delegate = self
                dropInViewController.paymentRequest = paymentRequest
                dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: UIBarButtonSystemItem.Cancel,
                    target: self, action: #selector(MyMembershipViewController.userDidCancelPayment))
                let navigationController = UINavigationController(rootViewController: dropInViewController)
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
            break
        default:
            break
        }
    }
    
    func isUpgradable(currentMemberShipLevel: Int, selectedMemberShipLevel: Int) -> Bool {
        
        var flag = false
        let gold = MemberShip.Gold.levelID
        let bronze = MemberShip.Bronze.levelID
        
        print("Gold \(gold)")
        print("Bronze \(bronze)")
        switch(currentMemberShipLevel, selectedMemberShipLevel) {
        case(bronze,bronze),(gold,gold),(gold,bronze):
            flag = false
            break
        case(bronze,gold):
            flag = true
            break
        default:
            break
        }
        return flag
    }
    
    
    func showAlert(value: Bool) -> UIAlertController {
        let alertController = value == true ? UIAlertController(title: "Change Membership Level", message: "Membership Level changed successfully", preferredStyle: .Alert) : UIAlertController(title: "Change MembershipLevel", message: "Membership Level could not be updated.Please try again later", preferredStyle: .Alert)
        let OkAction = UIAlertAction(title: "OK", style: .Default) { (alertAction) in
            self.performSegueWithIdentifier("unwindFromMymembership", sender: nil)
        }
        alertController.addAction(OkAction)
        return alertController
    }
}
