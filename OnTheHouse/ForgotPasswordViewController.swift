//
//  ForgotPasswordViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 2/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    let emailDelegate = RegistrationEmailValidationDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func configureTextField() {
        emailTextField.delegate = emailDelegate
    }
    
    @IBAction private func backToLogin() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func passwordResetAction() {
        if let email = emailTextField.text {
            let params = ["email": email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())]
            
            OTHService.sharedInstance.postDataToOTH("member/forgot-password", parameters: params) { (dictionary) in
                if !APIStatus.isSuccessfulResponse(dictionary) {
                    if let errorList = APIStatus.retrieveErrorMessage(dictionary) {
                        if let alert = APIStatus.showAlertMessageToUser(errorList) {
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    self.showAlert()
                }
            }
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Forgot Password", message: "You will soon receive a email that will contain instructions for retrieving password", preferredStyle: .Alert)
        let OkAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(OkAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
