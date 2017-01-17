//
//  UserAddressViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 12/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class UserAddressViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var statePickerView: UIPickerView!
    @IBOutlet weak var pinCodeTextField: UITextField!
    
    var pickerData: [String] = []
    
    let statePickerDelegate = StatePickerDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load")
        configureCountryPicker()
        configureStatePicker()
        configurePinCodeTextField()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print("will appear")
        self.countryPickerView.selectRow(12, inComponent: 0, animated: true)
        self.statePickerView.selectRow(6, inComponent: 0, animated: true)
    }
    
    private func configurePinCodeTextField() {
        pinCodeTextField.delegate = self
        pinCodeTextField.text = ""
    }
    
    private func configureStatePicker() {
        statePickerView.delegate = statePickerDelegate
        statePickerView.dataSource = statePickerDelegate
        self.statePickerView.selectRow(6, inComponent: 0, animated: true)
    }
    
    private func configureCountryPicker() {
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        OTHService.sharedInstance.getDataFromOTH("countries") { (dictionary) in
            self.pickerData = DataFormatter.getListOfCountries(dictionary)
            self.countryPickerView.reloadAllComponents()
            self.countryPickerView.selectRow(12, inComponent: 0, animated: true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func backToPreviousPage() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let countryCode = row + 1
        OTHService.sharedInstance.getDataFromOTH("zones/\(countryCode)") { (dictionary) in
            self.statePickerDelegate.pickerData = DataFormatter.getListOfStatesByCountryID(dictionary)
            self.statePickerView.reloadAllComponents()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NewMemberData.countryID = String(countryPickerView.selectedRowInComponent(0)+1)
        NewMemberData.zoneID = String(statePickerView.selectedRowInComponent(0)+1)
        NewMemberData.zip = String(pinCodeTextField.text!)
    }
}
