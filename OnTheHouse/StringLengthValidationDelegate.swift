//
//  StringLengthValidationDelegate.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 3/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import UIKit


class StringLengthValidationDelegate: NSObject, UITextFieldDelegate {
    // Tag 1 -  for Nick Name length: The length of the nick name must be greater than equal
    // than 6 characters
    
    // Tag 5 - for length of the contact number - it must be greater than 8
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var newText = textField.text! as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        var color: UIColor? = UIColor.blackColor()
        switch textField.tag {
        case 1:
            color = newText.length < 6 ? UIColor.redColor() : UIColor.blackColor()
            textField.textColor = color
        case 5:
            color = newText.length < 9 ? UIColor.redColor() : UIColor.blackColor()
            textField.textColor = color
        default:
            break
        }
        return newText.length < 17 ? true : false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
