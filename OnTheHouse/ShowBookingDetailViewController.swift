//
//  ShowBookingDetailViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 1/09/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//


// if the user is a Gold Member, then he does'nt have to pay for the ADMIN FEE.But if the ticket has a shipping fee, the user will have to pay the shipping fee.

// How to figure out whether the type of the ticket is a "Admin Fee" type or "discounted type"
// All the users have to pay the discounted fee but the Admin Fee is only paid by the Bronze Member


import UIKit
import Eureka
import Braintree

class ShowBookingDetailViewController: FormViewController, BTDropInViewControllerDelegate {
    
    var braintreeClient: BTAPIClient?
    var show: Show?
    var socialQuestion: [Question] = []
    var statesList: [State] = []
    var quantity: String?
    var reservatiovar: Int?
    var itemPrice: String?
    var userID: Int?
    var reservationInitializationObject: ReservationRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("******")
        print(show?.showID)
        print("******")
        userID = NSUserDefaults.standardUserDefaults().integerForKey("id")
        
        let tokenizationKey = "sandbox_ghhy8vjr_hyqznn8gm29j7xv2"
        braintreeClient = BTAPIClient(authorization: tokenizationKey)
        
        TextRow.defaultCellUpdate = { cell, row in cell.detailTextLabel?.textColor = .orangeColor()  }
        
        if show?.shipping == true {
            shippingForm()
        } else {
            questionAndAnswer()
        }
    }
    
    func shippingForm() {
        form
            +++ Section("How did you hear about the show ?")
            <<< PickerRow<String>("question") { (row : PickerRow<String>) -> Void in
                OTHService.sharedInstance.getDataFromOTH("questions/booking") { (dictionary) in
                    self.socialQuestion = DataFormatter.getCustomQuestionSetAsDictionary(.Booking, jsonDictionary: dictionary)
                    
                    row.tag = "question"
                    row.options = []
                    for question in self.socialQuestion {
                        row.options.append(question.questionName)
                    }
                    row.value = row.options[4]
                }
                }.onChange({ (row) in
                    print("change")
                })
            
            <<< TextRow(){ row in
                row.title = "Answer"
                row.placeholder = "Your Answer"
                row.tag = "userAnswer"
                row.hidden = "$question == 'Flyer' || $question == 'Cafe' || $question == 'Twitter' || $question == 'Facebook' || $question == 'www.on-the-house.org' || $question == 'ON THE HOUSE Newsletter' || $question == 'Ticketek/TicketMaster/Moshtix'"
            }
            
            +++ Section("Address - Please change the address if you wish to receive the tickets at a new addresss")
            <<< TextRow(){ row in
                row.title = "First Name"
                row.tag = "firstName"
                if let userName = NSUserDefaults.standardUserDefaults().stringForKey("firstName") {
                    row.value = userName
                    row.placeholder = row.value
                }
            }
            
            <<< TextRow(){ row in
                row.title = "Last Name"
                row.tag = "lastName"
                if let lastName = NSUserDefaults.standardUserDefaults().stringForKey("lastName") {
                    row.value = lastName
                    row.placeholder = row.value
                }
            }
            
            <<< TextRow(){
                $0.title = "email"
                $0.tag = "email"
                if let email = NSUserDefaults.standardUserDefaults().stringForKey("email") {
                    $0.value = email
                    $0.placeholder = $0.value
                }
            }
            
            <<< PhoneRow(){
                $0.title = "Phone Number"
                $0.tag = "phone"
                if let phone = NSUserDefaults.standardUserDefaults().stringForKey("phone") {
                    $0.value = phone
                    $0.placeholder = $0.value
                }
            }
            
            <<< TextRow(){ row in
                row.title = "Street"
                if let address = getFullUserAddress() {
                    row.value = address
                    row.placeholder = row.value
                }
                row.tag = "street"
            }
            
            <<< TextRow(){ row in
                row.title = "City"
                if let city = NSUserDefaults.standardUserDefaults().stringForKey("city") {
                    row.value = city
                    row.placeholder = row.value
                }
                row.tag = "city"
            }
            
            <<< PhoneRow(){
                $0.title = "Pin Code"
                let zip = NSUserDefaults.standardUserDefaults().integerForKey("zip")
                $0.value = String(zip)
                $0.placeholder = $0.value
                $0.tag = "pinCode"
            }
            
            +++ Section("State")
            <<< PickerRow<String>("State") { (row : PickerRow<String>) -> Void in
                OTHService.sharedInstance.getDataFromOTH("zones/13", completionHandler: { (dictionary) in
                    self.statesList = DataFormatter.getListOfStates(dictionary)
                    print(self.statesList)
                    row.tag = "state"
                    row.title = "State"
                    row.options = []
                    for state in self.statesList {
                        row.options.append(state.name)
                    }
                    let userStateID = NSUserDefaults.standardUserDefaults().integerForKey("state")
                    print("user state id: \(userStateID)")
                    let stateIndex = self.extractIndexFromStateName(userStateID)
                    
                    print("state Index \(stateIndex)")
                    if let userStateIndex = stateIndex {
                        row.value = row.options[userStateIndex]
                    }
                    row.reload()
                })
            }
            +++ Section("Update Address")
            <<< CheckRow("updateAddress") {
                $0.title = "Yes update my address ?"
                $0.value = true
        }
    }
    
    func questionAndAnswer() {
        form
            +++ Section("How did you hear about the show ?")
            <<< PickerRow<String>("question") { (row : PickerRow<String>) -> Void in
                OTHService.sharedInstance.getDataFromOTH("questions/booking") { (dictionary) in
                    self.socialQuestion = DataFormatter.getCustomQuestionSetAsDictionary(.Booking, jsonDictionary: dictionary)
                    
                    row.tag = "question"
                    row.options = []
                    for question in self.socialQuestion {
                        row.options.append(question.questionName)
                    }
                    row.value = row.options[4]
                }
            }/*.onChange({ (row) in
             if self.extractMultiPartStatusFromQuestionList(row.value!) {
             if let answerRow = self.form.rowByTag("userAnswer") as? TextRow {
             print("inside")
             answerRow.hidden = true
             }
             }
             })*/
            
            <<< TextRow(){ row in
                row.title = "Answer"
                row.placeholder = "Your Answer"
                row.tag = "userAnswer"
                print("$question")
                
                row.hidden = "$question == 'Flyer' || $question == 'Cafe' || $question == 'Twitter' || $question == 'Facebook' || $question == 'www.on-the-house.org' || $question == 'ON THE HOUSE Newsletter' || $question == 'Ticketek/TicketMaster/Moshtix'"
        }
    }
    
    func getValueFromForm() -> [String: String] {
        
        var userDetails: [String: String] = [:]
        
        if let showId = self.show?.showID {
            userDetails["show_id"] = String(showId)
        }
        
        userDetails["member_id"] = String(NSUserDefaults.standardUserDefaults().integerForKey("id"))
        
        if let quantity = self.quantity {
            userDetails["tickets"] = quantity
        }
        
        
        let valuesDictionary = form.values()
        print("*********")
        print(valuesDictionary)
        print("*********")
        
        if let questionName = valuesDictionary["question"] as? String {
            if let questionID = extractQuestionIDFromQuestionName(questionName) {
                userDetails["question_id"] = String(questionID)
            }
        }
        
        if let questionAnswer = valuesDictionary["userAnswer"] as? String {
            userDetails["question_text"] = questionAnswer
        }
        
        if self.show?.shipping == true {
            if let firstName = valuesDictionary["firstName"] as? String {
                print(firstName)
                userDetails["shipping_first_name"] = firstName
            } else {
                if let firstName = NSUserDefaults.standardUserDefaults().stringForKey("firstName") {
                    userDetails["shipping_first_name"] = firstName
                }
            }
            
            if let lastName = valuesDictionary["lastName"] as? String {
                userDetails["shipping_last_name"] = lastName
            } else {
                if let lastName = NSUserDefaults.standardUserDefaults().stringForKey("lastName") {
                    userDetails["shipping_last_name"] = lastName
                }
            }
            
            if let phone = valuesDictionary["phone"] as? String {
                userDetails["shipping_phone"] = phone
            } else {
                if let phone = NSUserDefaults.standardUserDefaults().stringForKey("phone") {
                    userDetails["shipping_phone"] = phone
                }
            }
            
            if let address = valuesDictionary["street"] as? String {
                userDetails["shipping_address1"] = address
            } else {
                if let streetAddress = getFullUserAddress(){
                    userDetails["shipping_address1"] = streetAddress
                }
            }
            
            if let city = valuesDictionary["city"] as? String {
                userDetails["shipping_city"] = city
            } else {
                if let city = NSUserDefaults.standardUserDefaults().stringForKey("city") {
                    userDetails["shipping_city"] = city
                }
            }
            
            if let pinCode = valuesDictionary["pinCode"] as? String {
                userDetails["shipping_zip"] = pinCode
            } else {
                let zip = NSUserDefaults.standardUserDefaults().integerForKey("zip")
                userDetails["shipping_zip"] = String(zip)
            }
            
            if let stateName = valuesDictionary["state"] as? String {
                if let stateId = extractStateIDFromStateName(stateName) {
                    userDetails["shipping_zone_id"] = String(stateId)
                }
            } else {
                let state = NSUserDefaults.standardUserDefaults().integerForKey("state")
                userDetails["shipping_zone_id"] = String(state)
            }
            
            if let updateAddresFlag = valuesDictionary["updateAddress"] as? Bool {
                userDetails["shipping_save_info"] = updateAddresFlag == true ? String(1) : String(0)
            } else {
                userDetails["shipping_save_info"] = String(0)
            }
        }
        return userDetails
    }
    
    func extractStateIDFromStateName(name: String) -> Int? {
        for i in 0..<self.statesList.count {
            if self.statesList[i].name == name {
                return self.statesList[i].id
            }
        }
        return nil
    }
    
    func extractQuestionIDFromQuestionName(name: String) -> Int? {
        print(name)
        for i in 0..<self.socialQuestion.count {
            if self.socialQuestion[i].questionName == name {
                return self.socialQuestion[i].questionID
            }
        }
        return nil
    }
    
    func extractMultiPartStatusFromQuestionList(name: String) -> Bool {
        for i in 0..<self.socialQuestion.count {
            if self.socialQuestion[i].questionName == name {
                return self.socialQuestion[i].isMultipart == true ? true : false
            }
        }
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backToBookingPage(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if let questionRow = form.rowByTag("question") as? PickerRow<String> {
            questionRow.reload()
        }
    }
    
    // Braintree
    
    func userDidCancelPayment() {
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
        
        let finalParams = preparePaymentCompletionParams(finalNonce)
        
        ReservationHelper.sendPaymentConfirmationToOTH(finalParams) { (result) in
            print(result)
            
            self.dismissViewControllerAnimated(true, completion: {
                self.showAlert(result)
            })
        }
        
    }
    
    @IBAction func showAlert(result: Bool) {
        var title = ""
        var message = ""
        switch(result) {
        case true:
            title = "Booking Complete"
            message = "On The House has successfully received the payment"
            break
        case false:
            title = "Payment Unsuccessful"
            message = "Sorry payment could not be processed,please try again later"
            break
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.performSegueWithIdentifier("back_to_event_master", sender: action)
        }
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func sendPaymentConfirmationToOTH(params: [String: String], completion: (Bool) -> ()) {
        print("starting call")
        
        OTHService.sharedInstance.postDataToOTH("reserve/complete", parameters: params, completionHandler: { (dictionary) in
            print(dictionary)
            
            guard let status = dictionary["status"] as? String else {
                return
            }
            completion(status == "success" ? true : false)
        })
    }
    
    func preparePaymentCompletionParams(nonce: String) -> [String: AnyObject] {
        var paymentParams: [String: AnyObject] = [:]
        var finalPrice = 0.0
        
        if let price = self.reservationInitializationObject?.itemPrice {
            finalPrice += price
        }
        
        if let shippingPrice = self.reservationInitializationObject?.shippingPrice {
            finalPrice += shippingPrice
        }
        
        paymentParams["price"] = finalPrice
        
        if let reservationID = self.reservationInitializationObject?.reservationId {
            paymentParams["reservation_id"] = String(reservationID)
        }
        
        paymentParams["nonce"] = nonce
        
        paymentParams["member_id"] = String(NSUserDefaults.standardUserDefaults().integerForKey("id"))
        
        if let ticketQuantity = self.quantity {
            paymentParams["tickets"] = ticketQuantity
        }
        
        
        if let showID = self.show?.showID {
            paymentParams["show_id"] = String(showID)
        }
        
        print("*********")
        print(paymentParams)
        print("*********")
        return paymentParams
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tappedMyPayButton() {
        let userFormValues = getValueFromForm()
        print(userFormValues)
        
        sendReservationRequestToServer(userFormValues) { (paymentRequest) in
            if let paymentRequest = paymentRequest {
                let dropInViewController = BTDropInViewController(APIClient: self.braintreeClient!)
                dropInViewController.paymentRequest = paymentRequest
                dropInViewController.delegate = self
                dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: UIBarButtonSystemItem.Cancel,
                    target: self, action: #selector(ShowBookingDetailViewController.userDidCancelPayment))
                let navigationController = UINavigationController(rootViewController: dropInViewController)
                self.presentViewController(navigationController, animated: true, completion: nil)
            } else {
                if let reservationObject = self.reservationInitializationObject {
                    print(reservationObject.affiliateUrl)
                    self.performSegueWithIdentifier("externalLink", sender: nil)
                }
            }
        }
    }
    
    func extractIndexFromStateName(stateID: Int) -> Int? {
        print("inside")
        for i in 0..<self.statesList.count {
            print(statesList[i].id)
            if self.statesList[i].id == stateID {
                return i
            }
        }
        return nil
    }
    
    func getFullUserAddress() -> String? {
        var finalAddress = ""
        if let street1 = NSUserDefaults.standardUserDefaults().stringForKey("address1") {
            finalAddress += street1 + " "
        }
        
        if let street2 = NSUserDefaults.standardUserDefaults().stringForKey("address2") {
            finalAddress += street2
        }
        return finalAddress == "" ? nil : finalAddress
    }
    
    func sendReservationRequestToServer(userForm: [String: String], completion: (BTPaymentRequest?) -> ()) {
        ReservationHelper.sendReservationRequest(userForm) { (requestObject, alertController) in
            if let requestObject = requestObject {
                print("**********checking reservation obj *************")
                print(requestObject.affiliateUrl)
                print(requestObject.itemName)
                print(requestObject.reservationId)
                print(requestObject.shippingPrice)
                print(requestObject.paypal)
                print(requestObject.itemPrice)
                print("********** checking end *********")
                
                self.reservationInitializationObject = requestObject
                if let quantity = self.quantity {
                    self.reservationInitializationObject?.itemQuantity = Int(quantity)
                }
                print("***********************")
                if let finalReservationRequest = self.reservationInitializationObject {
                    if finalReservationRequest.affiliateUrl != nil {
                        completion(nil)
                    } else if finalReservationRequest.paypal == false {
                        self.showAlert(true)
                        completion(nil)
                    } else {
                        completion(self.configureBraintreePaymentRequest(finalReservationRequest))
                    }
                }
            } else {
                // notify user about the problem
                if let alertController = alertController {
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func configureBraintreePaymentRequest(reservationObject: ReservationRequest) -> BTPaymentRequest {
        print("payment request configuration")
        
        // in case when the user only has to pay for the shipping , the item price is same as shipping price,other wise we 
        // get two seperate fields item price and shipping price
        let paymentRequest = BTPaymentRequest()
        var paymentDescription = ""
        if let title = reservationObject.itemName {
            paymentRequest.summaryTitle = title
        }
        
        if let quantity = reservationObject.itemQuantity {
            paymentDescription += "Quantity:" + String(quantity)
        }
        
        var finalPayPalAmount = 0.0
        
        if let price = reservationObject.itemPrice {
            finalPayPalAmount += price
        }
        
        if let shippingPrice = reservationObject.shippingPrice {
            finalPayPalAmount += shippingPrice
            paymentDescription += "Shipping Price: $ \(shippingPrice)\n"
        } else {
            print("shipping price is not returned by the server")
        }
        
        paymentRequest.displayAmount = "$ \(finalPayPalAmount)"
        paymentRequest.amount = String(finalPayPalAmount)
        paymentRequest.summaryDescription = paymentDescription
        paymentRequest.additionalPayPalScopes = Set(["address"])
        return paymentRequest
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "externalLink" {
            let destinationController = segue.destinationViewController as? AffiliateLinkWebViewController
            destinationController?.url = self.reservationInitializationObject?.affiliateUrl
        }
    }
}