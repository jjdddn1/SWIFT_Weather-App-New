//
//  AddCityViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/4/20.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import Spring
import Alamofire

class AddCityViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var beforeViewController: SearchHistoryViewController!

    @IBOutlet weak var backGroundView: SpringView!
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    let stateArray = ["",
                      "AL",
                      "AK",
                      "AZ",
                      "AR",
                      "CA",
                      "CO",
                      "CT",
                      "DE",
                      "DC",
                      "FL",
                      "GA",
                      "HI",
                      "ID",
                      "IL",
                      "IN",
                      "IA",
                      "KS",
                      "KY",
                      "LA",
                      "ME",
                      "MD",
                      "MA",
                      "MI",
                      "MN",
                      "MS",
                      "MO",
                      "MT",
                      "NE",
                      "NV",
                      "NH",
                      "NJ",
                      "NM",
                      "NY",
                      "NC",
                      "ND",
                      "OH",
                      "OK",
                      "OR",
                      "PA",
                      "RI",
                      "SC",
                      "SD",
                      "TN",
                      "TX",
                      "UT",
                      "VT",
                      "VA",
                      "WA",
                      "WV",
                      "WI",
                      "WY"]

    var setError: String {
        get{
            return errorMessageLabel.text!
        }
        set{
            errorMessageLabel.text = newValue
        }
    }
    var needCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUpUI(){
        backGroundView.layer.cornerRadius = 10
        let paddingView = UIView.init(frame: CGRectMake(0, 0, 8, 30))
        cityTextField.leftView = paddingView
        cityTextField.leftViewMode = UITextFieldViewMode.Always
        cityTextField.attributedPlaceholder = NSAttributedString(string:"Enter the city name",
                                                          attributes:[NSFontAttributeName:UIFont(name: "Trebuchet MS", size: 15.0)!,NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        
        let paddingView2 = UIView.init(frame: CGRectMake(0, 0, 8, 30))
        stateTextField.leftView = paddingView2
        stateTextField.leftViewMode = UITextFieldViewMode.Always
        stateTextField.attributedPlaceholder = NSAttributedString(string:"Enter or select state name",
                                                                 attributes:[NSFontAttributeName:UIFont(name: "Trebuchet MS", size: 15.0)!,NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        addButton.layer.cornerRadius = 5
        addButton.layer.borderColor = UIColor.whiteColor().CGColor
        addButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderColor = UIColor.whiteColor().CGColor
        cancelButton.layer.borderWidth = 1

        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTextField.text = stateArray[row]
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if needCheck {
            checkError()
        }
    }
    
    func checkError() -> Bool{
        needCheck = true
        if(cityTextField.text == ""){
            setError = "Please Enter a City Name"
            return false
        }else if(stateTextField.text == ""){
            setError = "Please Select a State"
            return false
        }else{
            setError = ""
            return true
        }
    }
    
    @IBAction func AddButtonPressed(sender: UIButton) {
        if checkError(){
            let loc = Location(city: cityTextField.text!, state: stateTextField.text!)
            DataStruct.cities.append(loc!)
            CancelButtonPressed(UIButton())
            beforeViewController.editButtonPressed(UIButton())
            beforeViewController.setTitle()
        }
    }
    
    @IBAction func CancelButtonPressed(sender: UIButton) {
        backGroundView.animation = "fall"
        backGroundView.animateNext {
            self.dismissViewControllerAnimated(false, completion: nil)
        }

    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
        }
        let myTitle = NSAttributedString(string: stateArray[row], attributes: [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 18.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center
        return pickerLabel
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
