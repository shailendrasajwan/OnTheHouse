//
//  StateViewController.swift
//  OnTheHouse
//
//  Created by Mitul Manish on 12/08/2016.
//  Copyright © 2016 Mitul Manish. All rights reserved.
//

import UIKit

class SocialAnswerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {
    
    var socialData = [""]
    let timeZonePickerDelegate = TimeZonePickerDelegate()
    var questions: [Question] = []
    
    @IBOutlet weak var hearAboutUsPickerView: UIPickerView!
    @IBOutlet weak var answerTexField: UITextField!
    @IBOutlet weak var timeZonePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load")
        configureAnswerTextField()
        configureSocialPicker()
        configureTimeZonePicker()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print("will appear")
        self.timeZonePickerView.selectRow(105, inComponent: 0, animated: true)
        self.hearAboutUsPickerView.selectRow(4, inComponent: 0, animated: true)
    }
    
    private func configureAnswerTextField() {
        answerTexField.delegate = self
        answerTexField.text = ""
    }
    
    private func configureSocialPicker() {
        hearAboutUsPickerView.delegate = self
        hearAboutUsPickerView.dataSource = self
        OTHService.sharedInstance.getDataFromOTH("questions/member") { (data) in
            self.questions = DataFormatter.getQuestionSetAsDictionary(data)
            var questionsList: [String] = []
            
            for question in self.questions {
                questionsList.append(question.questionName)
            }
            
            self.socialData = questionsList
            self.hearAboutUsPickerView.reloadAllComponents()
            self.hearAboutUsPickerView.selectRow(4, inComponent: 0, animated: true)
        }
    }
    
    private func configureTimeZonePicker() {
        timeZonePickerView.delegate = timeZonePickerDelegate
        timeZonePickerView.dataSource = timeZonePickerDelegate
        OTHService.sharedInstance.getDataFromOTH("timezones") { (data) in
            self.timeZonePickerDelegate.timeZoneData = DataFormatter.getTimeZonesAsList(data)
            self.timeZonePickerView.reloadAllComponents()
            self.timeZonePickerView.selectRow(105, inComponent: 0, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToPreviousPage(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return socialData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return socialData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(socialData[row])
        answerTexField.hidden = decideVisibilityOfAnswerTextField(row)
    }
    
    func decideVisibilityOfAnswerTextField(row: Int) -> Bool {
        return questions[row].isMultipart == true ? false : true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NewMemberData.questionID = String(hearAboutUsPickerView.selectedRowInComponent(0)+1)
        NewMemberData.timezoneID = String(timeZonePickerView.selectedRowInComponent(0)+1)
        NewMemberData.questionText = answerTexField.text!
    }
}
