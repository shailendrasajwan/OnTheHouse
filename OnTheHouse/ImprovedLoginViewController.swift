//
//  ImprovedLoginViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 9/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//
import UIKit
import Alamofire

class ImprovedLoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var activityIndiactor: UIActivityIndicatorView!
    
    let emailDelegate = EmailValidationDelegate()
    let passwordDelegate = PasswordValidationDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndiactor.hidesWhenStopped = true
        activityIndiactor.hidden = true
        configureTextFields()
    }
    
    func URLEncode(string: String) -> String {
        let generalDelimiters = ":#[]@ " // does not include "?" or "/" due to RFC 3986
        let subDelimiters = "!$&'()*+,;="
        
        let allowedCharacters = generalDelimiters + subDelimiters
        let customAllowedSet =  NSCharacterSet(charactersInString:allowedCharacters).invertedSet
        let escapedString = string.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)!
        
        return escapedString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func configureTextFields() {
        emailTextField.delegate = emailDelegate
        passwordTextfield.delegate = passwordDelegate
    }
    
    private func prepareDataForSignIn() -> [String: String] {
        
         let email = emailTextField.text
         let password = passwordTextfield.text
         
         let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
         let finalPassword = password!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
         
         return ["email": finalEmail, "password": finalPassword]
        //return ["email": "mitul.manish@gmail.com", "password": "mitul2311"]
    }
    
    
    @IBAction private func signInAction() {
        activityIndiactor.hidden = false
        activityIndiactor.startAnimating()
        OTHService.sharedInstance.postDataToOTH("member/login", parameters: prepareDataForSignIn(), completionHandler: { (dictionary) in
            if !APIStatus.isSuccessfulResponse(dictionary) {
                self.activityIndiactor.stopAnimating()
                if let list = APIStatus.retrieveErrorMessage(dictionary) {
                    print(list)
                    if let alert = APIStatus.showAlertMessageToUser(list) {
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            } else {
                _ = Member(data: (dictionary["member"] as? [String: AnyObject])!)
                self.activityIndiactor.stopAnimating()
                self.performSegueWithIdentifier("eventMaster", sender: nil)
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let loggedInStatus = NSUserDefaults.standardUserDefaults().boolForKey("loggin_in")
        
        if loggedInStatus {
            self.performSegueWithIdentifier("eventMaster", sender: nil)
        }
    }
    
    
    private func emailAndPasswordPresent() -> Bool {
        return (emailTextField.text!.isEmpty || passwordTextfield.text!.isEmpty) ? false : true
    }
    
    @IBAction func unwindToLogIn(segue: UIStoryboardSegue) { }
    
    
    @IBAction func forgotPasswordAction(sender: AnyObject) {
        self.performSegueWithIdentifier("forgot_password", sender: sender)
    }
    
}