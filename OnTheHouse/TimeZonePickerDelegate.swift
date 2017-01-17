//
//  TimeZonePickerDelegate.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 14/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import Foundation
import UIKit
class TimeZonePickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    var timeZoneData: [String] = ["(GMT +10:00) Melbourne"]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeZoneData.count
    }
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeZoneData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerView.tag)
    }
}
