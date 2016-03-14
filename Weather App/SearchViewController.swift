//
//  SearchViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/13.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class SearchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    var beforeViewController: WelcomeViewController!
    
    let stateArray = ["Select",
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
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var selectState: UIButton!

    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var clear: UIButton!
    
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    var setError: String {
        get{
            return errorMessage.text!
        }
        set{
            errorMessage.text = newValue
        }
    }
    
    @IBAction func selectState(sender: UIButton) {
        self.view.endEditing(true)
        if(pickerView.hidden == true){
            searchClearMoveDown()
        }else{
            searchClearMoveUp()
        }
    }
    
    func searchClearMoveDown(){
        self.pickerView.hidden = false
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.search.transform = CGAffineTransformMakeTranslation(0, 50)
            self.search.alpha = 0
            self.clear.transform = CGAffineTransformMakeTranslation(0, 50)
            self.search.alpha = 0
            self.clear.alpha = 0
            self.pickerView.alpha = 1
            }, completion: nil)
        
    }
    func searchClearMoveUp(){
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.search.transform = CGAffineTransformMakeTranslation(0, 0)
            self.clear.transform = CGAffineTransformMakeTranslation(0, 0)
            self.clear.alpha = 1
            self.search.alpha = 1
            self.pickerView.alpha = 0
            }){(Bool) -> Void in
            self.pickerView.hidden = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.layer.cornerRadius = 4;
        clear.layer.cornerRadius = 4;
        pickerView.hidden = true
        pickerView.alpha = 0
        let paddingView = UIView.init(frame: CGRectMake(0, 0, 8, 30))
        street.leftView = paddingView;
        street.leftViewMode = UITextFieldViewMode.Always
        street.attributedPlaceholder = NSAttributedString(string:"Street address",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        let paddingView2 = UIView.init(frame: CGRectMake(0, 0, 8, 30))
        city.leftView = paddingView2;
        city.leftViewMode = UITextFieldViewMode.Always
        city.attributedPlaceholder = NSAttributedString(string:"City",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        DataStruct.needCheck = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpUI()
    }
    func setUpUI(){
        self.view.transform = CGAffineTransformMakeTranslation(0, -self.view.bounds.height)
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: nil)
    }
    @IBAction func swipeUp(sender: UISwipeGestureRecognizer) {
        viewDisappear()
    }
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        historyButtonPressed(UIButton())
    }
    func viewDisappear(){
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view.transform = CGAffineTransformMakeTranslation(0, -self.view.bounds.height)
            self.beforeViewController.everythingGetBackToOriginPosition()
            }){(Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: nil)
                
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(DataStruct.needCheck){
            checkError()
        }
        textField.resignFirstResponder()
        return false
    }
    
    func checkError() -> Bool{
        DataStruct.needCheck = true
        if(street.text == ""){
            setError = "Please Enter a Street Address"
            return false
        }else if(city.text == ""){
            setError = "Please Enter a City Name"
            return false
        }else if(selectState.currentTitle == "  Select"){
            setError = "Please Select a State"
            return false
        }else{
            setError = ""
            return true
        }
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
        selectState.setTitle("  "+stateArray[row], forState:UIControlState.Normal)
        if(DataStruct.needCheck && selectState.currentTitle == "  Select"){
            setError = "Please Select a State"
        }else{
            setError = ""
        }
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            let hue = CGFloat(row)/CGFloat(stateArray.count)
            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        let titleData = stateArray[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center
        return pickerLabel
        
    }
    
    @IBAction func search(sender: UIButton) {
        self.view.endEditing(true)
        if checkError() {
            setError = ""
            let state : String = (selectState.currentTitle! as NSString).substringFromIndex(2)
            let url = createUrl(street.text! ,cityV: city.text!, stateV: state, fahrenheitV: DataStruct.fahrenheit)
            getJson(NSURL(string: url)!)
            print(url)
        }
    }
    
    func getJson(url : NSURL){
        disableSearchKey()
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if(json["currently"]["temperature"] != nil){
                        DataStruct.jsonfile = json
                        DataStruct.street = self.street.text!
                        DataStruct.city = self.city.text!
                        DataStruct.state = (self.selectState.currentTitle! as NSString).substringFromIndex(2)
                        
                        self.saveData()
                        self.swipeUp(UISwipeGestureRecognizer())

                        self.beforeViewController.setWeatherInfo()
                        
                        print("success")
                    }else{
                        self.setError = "Invalid Location Information"
                        DataStruct.hasError = false
                    }
                }
            case .Failure:
                print("Get JSON Failure")
                break
            }
            self.enableSearchKey()
        }

    }
    
    func saveData(){
        //store the history in coreData
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("History", inManagedObjectContext: managedContext)
        
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        item.setValue(DataStruct.city, forKey: "city")
        item.setValue(DataStruct.state, forKey: "state")
        item.setValue(DataStruct.street, forKey: "street")
        do{
            try managedContext.save()
            
        }catch{
            print("Error")
        }
    }
    
    func createUrl( streetV : String , cityV : String , stateV : String , fahrenheitV: Bool) -> String {
        let urlBase = "http://huiyuanr-env.elasticbeanstalk.com/?"
        let url = urlBase + ("street_address=" + streetV + "&city=" + cityV + "&state=" + stateV + "&degree=" + (fahrenheitV ? "fahrenheit": "celsius")).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!

        return url
    }

    @IBAction func clear(sender: UIButton) {
        DataStruct.needCheck = false
        selectState.setTitle("  "+stateArray[0], forState:UIControlState.Normal)

        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.hidden = true
        street.text = ""
        city.text = ""
        setError = ""
        self.view.endEditing(true)
        
    }
    @IBAction func historyButtonPressed(sender: UIButton) {
        self.performSegueWithIdentifier("showHistorySegue", sender: self)
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.view.transform = CGAffineTransformMakeTranslation(-self.view.bounds.width, 0)
            self.beforeViewController.backGroundImageView.transform = CGAffineTransformTranslate(self.beforeViewController.backGroundImageView.transform, -self.view.bounds.width, 0)
            }) { (Bool) -> Void in
                
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(DataStruct.needCheck){
            checkError()
        }
        self.view.endEditing(true)
        searchClearMoveUp()
    }

    func everythingGetBackToOriginPosition(){
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.view.transform = CGAffineTransformMakeTranslation(0, 0)
            self.beforeViewController.backGroundImageView.transform = CGAffineTransformTranslate(self.beforeViewController.backGroundImageView.transform, self.view.bounds.width, 0)
            }) { (Bool) -> Void in
                
        }

    }
    
    func enableSearchKey(){
        self.search.enabled = true
        self.search.backgroundColor = UIColor(red: 128/255, green: 0, blue: 1, alpha: 1)
    }
    func disableSearchKey(){
        self.search.enabled = false
        self.search.backgroundColor = UIColor.grayColor()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHistorySegue" {
            let des = segue.destinationViewController as! HistoryViewController
            des.beforeViewController = self
        }
    }

}
