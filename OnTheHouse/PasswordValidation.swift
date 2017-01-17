//
//  PasswordValidation.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 3/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import UIKit

class PasswordValidationDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let lightColor = UIColor(red: 228/255, green: 241/255, blue: 254/255, alpha: 1)
        var newText = textField.text! as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        let color = newText.length < 8 ? lightColor : UIColor.whiteColor()
        textField.textColor = color
        return newText.length < 17 ? true : false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class RegistrationPasswordValidationDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var newText = textField.text! as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        let color = newText.length < 8 ? UIColor.redColor() : UIColor.blackColor()
        textField.textColor = color
        return newText.length < 17 ? true : false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}