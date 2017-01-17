//
//  BookingDetailsViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 29/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Braintree

class BookingDetailsViewController: UIViewController, BTDropInViewControllerDelegate {
    
    var braintreeClient: BTAPIClient?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tokenizationKey = "sandbox_ghhy8vjr_hyqznn8gm29j7xv2"
        braintreeClient = BTAPIClient(authorization: tokenizationKey)
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedMyPayButton() {
        
        // If you haven't already, create and retain a `BTAPIClient` instance with a
        // tokenization key OR a client token from your server.
        // Typically, you only need to do this once per session.
        
        
        
        // Create a BTDropInViewController
        
        
        let dropInViewController = BTDropInViewController(APIClient: braintreeClient!)
        
        let paymentRequest = BTPaymentRequest()
        
        paymentRequest.summaryTitle = "1 Yellow T-Shirt"
        paymentRequest.summaryDescription = "Ships in five days"
        paymentRequest.displayAmount = "$100.95"
        //paymentRequest.shippingAddress = BTPostalAddress()
        paymentRequest.amount = "100.95"
        paymentRequest.additionalPayPalScopes = Set(["address"])
        
        paymentRequest.displayAmount = "$100.95"
        paymentRequest.amount = "100.95"
        dropInViewController.paymentRequest = paymentRequest
        
        dropInViewController.delegate = self
        
        // This is where you might want to customize your view controller (see below)
        
        // The way you present your BTDropInViewController instance is up to you.
        // In this example, we wrap it in a new, modally-presented navigation controller:
        dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Cancel,
            target: self, action: #selector(BookingDetailsViewController.userDidCancelPayment))
        let navigationController = UINavigationController(rootViewController: dropInViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func userDidCancelPayment() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewController(viewController: BTDropInViewController,
                              didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce)
    {
        
        if let payPalAccountNonce = paymentMethodNonce as? BTPayPalAccountNonce {
            print("*****PayPal")
            print(payPalAccountNonce.nonce)
            print(payPalAccountNonce.email)
            print(payPalAccountNonce.firstName)
            print(payPalAccountNonce.lastName)
            print("*******")
            print(payPalAccountNonce.billingAddress?.streetAddress)
            print(payPalAccountNonce.billingAddress?.postalCode)
            print(payPalAccountNonce.billingAddress?.recipientName)
            print(payPalAccountNonce.billingAddress?.region)
            print("*******")
            print(payPalAccountNonce.clientMetadataId)
            print(payPalAccountNonce.payerId)
            print(payPalAccountNonce.phone)
        } else {
            print("Nothing")
            // Send payment method nonce to your server for processing
            //contact server
            print("************")
            print(paymentMethodNonce.nonce)
            
            print("************")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
