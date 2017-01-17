//
//  RegisterUserViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 2/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit
import Alamofire

struct ErrorMessages {
    static let passwordsDoNotMatch = "passwords do not match"
    static let invalidEmail = "You must provide a valid email"
    static let nickNameTooShort = "Your nick name must be longer than 5 characters"
    static let passwordTooShort = "Password must be longer than 7 characters"
}
class RegisterUserViewController: UIViewController {
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nickNameSuggestionLabel: UILabel!
    @IBOutlet weak var emailSuggestionLabel: UILabel!
    @IBOutlet weak var passwordSuggestionLabel: UILabel!
    @IBOutlet weak var confirmPasswordSuggestionLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    let stringLengthValidation = StringLengthValidationDelegate()
    let emailDelegate = EmailValidationDelegate()
    let passwordDelegate = PasswordValidationDelegate()
    let registrationEmailDelegate = RegistrationEmailValidationDelegate()
    let registrationPasswordValidation = RegistrationPasswordValidationDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        addTargetToTextFields()
    }
    
    func addTargetToTextFields() {
        nickNameTextField.addTarget(self, action: #selector(RegisterUserViewController.provideSuggestionNickname(_:)), forControlEvents: UIControlEvents.EditingChanged)
        emailTextField.addTarget(self, action: #selector(RegisterUserViewController.provideSuggestionEmail(_:)), forControlEvents: UIControlEvents.EditingChanged)
        passwordTextField.addTarget(self, action: #selector(RegisterUserViewController.provideSuggestionPassword(_:)), forControlEvents: UIControlEvents.EditingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(RegisterUserViewController.provideSuggestionConfirmPassword(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    // :TODO Dry up the code
    func provideSuggestionNickname(sender: UITextField) {
        if let text = sender.text {
            if text.isEmpty {
                nickNameSuggestionLabel.text = ""
            } else {
                if text.characters.count < 6 {
                    nickNameSuggestionLabel.text = "At least 6 characters"
                } else {
                    nickNameSuggestionLabel.text = "✅"
                }
            }
        }
    }
    
    func provideSuggestionEmail(sender: UITextField) {
        if let text = sender.text {
            if text.isEmpty {
                emailSuggestionLabel.text = ""
            } else {
                if validateEmail(text) {
                    emailSuggestionLabel.text = "✅"
                } else {
                    emailSuggestionLabel.text = "Not a valid email"
                }
            }
        }
    }
    
    func provideSuggestionPassword(sender: UITextField) {
        if let text = sender.text {
            if text.isEmpty {
                passwordSuggestionLabel.text = ""
            } else {
                if text.characters.count < 8 {
                    passwordSuggestionLabel.text = "At least 8 characters"
                } else {
                    passwordSuggestionLabel.text = "✅"
                }
            }
        }
    }
    
    func provideSuggestionConfirmPassword(sender: UITextField) {
        if let passwordText = passwordTextField.text {
            if let text = sender.text {
                if text.isEmpty {
                    confirmPasswordSuggestionLabel.text = ""
                } else {
                    if text == passwordText {
                        confirmPasswordSuggestionLabel.text = "✅"
                    } else {
                        confirmPasswordSuggestionLabel.text = "Passwords do not match"
                    }
                }
            }
        }
    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    private func configureTextFields() {
        nickNameTextField.delegate = stringLengthValidation
        emailTextField.delegate = registrationEmailDelegate
        passwordTextField.delegate = registrationPasswordValidation
        confirmPasswordTextField.delegate = registrationPasswordValidation
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }
    
    @IBAction private func backToLogin() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func prepareDataForSignUp() {
        
        if let email = emailTextField.text{
            NewMemberData.email = email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
        if let password = passwordTextField.text {
            NewMemberData.password = password.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
        if let confirmPassword = confirmPasswordTextField.text {
            NewMemberData.passwordConfirm = confirmPassword.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
        if let nickName = nickNameTextField.text {
            NewMemberData.nickName = nickName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
        if let firstName = firstNameTextField.text {
            NewMemberData.firstName = firstName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
        if let lastName = lastNameTextField.text {
            NewMemberData.lastName = lastName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        }
    }
    
    
    @IBAction private func createAccountOnOTH() {
        prepareDataForSignUp()
        OTHService.sharedInstance.postDataToOTH("member/create", parameters: NewMemberData.getParameters()) { (dictionary) in
            if !APIStatus.isSuccessfulResponse(dictionary) {
                if let list = APIStatus.retrieveErrorMessage(dictionary) {
                    if let alert = APIStatus.showAlertMessageToUser(list) {
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            } else {
                let alertController = UIAlertController(title: "Message", message: "You have successfully created an account on On The House", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                    self.performSegueWithIdentifier("user_created_segue", sender: nil)
                })
                alertController.addAction(OKAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension RegisterUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
