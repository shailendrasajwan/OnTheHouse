//
//  PayPalPaymentViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 30/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Braintree

class PayPalPaymentViewController: UIViewController, BTViewControllerPresentingDelegate {
    
    var braintreeClient: BTAPIClient?

    override func viewDidLoad() {
        super.viewDidLoad()
        let tokenizationKey = "sandbox_ghhy8vjr_hyqznn8gm29j7xv2"
        braintreeClient = BTAPIClient(authorization: tokenizationKey)
        
        let customPayPalButton = UIButton(frame: CGRectMake(0, 0, 60, 120))
        customPayPalButton.addTarget(self, action: #selector(PayPalPaymentViewController.customPayPalButtonTapped(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(customPayPalButton)
    }
    
    func customPayPalButtonTapped(button: UIButton) {
        let payPalDriver = BTPayPalDriver(APIClient: self.braintreeClient!)
        payPalDriver.viewControllerPresentingDelegate = self
        //payPalDriver.appSwitchDelegate = self
        
        // Start the Vault flow, or...
        //payPalDriver.authorizeAccountWithCompletion() { (tokenizedPayPalAccount, error) -> Void in
          
        //}
        
        // ...start the Checkout flow
        let payPalRequest = BTPayPalRequest(amount: "1.00")
        payPalDriver.requestOneTimePayment(payPalRequest) { (tokenizedPayPalAccount, error) -> Void in
          print(tokenizedPayPalAccount?.nonce)
        }
    }
    
    // MARK: - BTViewControllerPresentingDelegate
    
    func paymentDriver(driver: AnyObject, requestsPresentationOfViewController viewController: UIViewController) {
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(driver: AnyObject, requestsDismissalOfViewController viewController: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
