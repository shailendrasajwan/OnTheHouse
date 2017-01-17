//
//  CustomizedUIButton.swift
//  OnTheHouse
//
//  Created by Danielle Hendricks on 27/10/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

@IBDesignable
class CustomizedUIButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
    @IBInspectable var bgColor: UIColor? {
        didSet {
            backgroundColor = bgColor
        }
    }
}
