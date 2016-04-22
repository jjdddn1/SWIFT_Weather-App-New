//
//  ViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/11.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class WelcomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var weatherAppLabel: UILabel!
    @IBOutlet weak var backGroundImageView: UIImageView!
    
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    
    @IBOutlet weak var lowHighTempLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var tempUnitLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var FirstDayLabel: UILabel!
    @IBOutlet weak var SecondDayLabel: UILabel!
    @IBOutlet weak var ThirdDayLabel: UILabel!
    @IBOutlet weak var FourthDayLabel: UILabel!
    @IBOutlet weak var FifthDayLabel: UILabel!
    
    @IBOutlet weak var FirstIconImageView: UIImageView!
    @IBOutlet weak var SecondIconImageView: UIImageView!
    @IBOutlet weak var ThirdIconImageView: UIImageView!
    @IBOutlet weak var FourthIconImageView: UIImageView!
    @IBOutlet weak var FifthIconImageView: UIImageView!
    
    @IBOutlet weak var FirstTempLabel: UILabel!
    @IBOutlet weak var SecondTempLabel: UILabel!
    @IBOutlet weak var ThirdTempLabel: UILabel!
    @IBOutlet weak var FourthTempLabel: UILabel!
    @IBOutlet weak var FifthTempLabel: UILabel!
    
    var haveCurrentLocation = false
    let locationManager = CLLocationManager()
    
    var arrowAnimation = false

    
    var distance : CGFloat = 0.0
    
    @IBOutlet weak var spinerImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DataStruct.welcomeViewController = self
        spinerImageView.image = UIImage.gifWithName("loading2")
        spinerImageView.hidden = false
        self.view.userInteractionEnabled = false
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        setUpUI()
        
        DataStruct.cities.removeAll()
        let newLoc1 = Location(city: "Beijing", state: "China")
        let newLoc2 = Location(city: "HeBei", state: "China")
        let newLoc3 = Location(city: "Shanghai", state: "China")
        let newLoc4 = Location(city: "Shandong", state: "China")

        DataStruct.cities.append(newLoc1!)
        DataStruct.cities.append(newLoc2!)
        DataStruct.cities.append(newLoc3!)
        DataStruct.cities.append(newLoc4!)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func viewDidAppear(animated: Bool) {
        self.distance = self.weatherAppLabel.center.y -  self.upButton.center.y - 60
    }
    
    func setUpUI(){
        self.leftButton.alpha = 0
        self.rightButton.alpha = 0
        self.upButton.alpha = 0
        self.downButton.alpha = 0
        currentWeatherImageView.alpha = 0
        lowHighTempLabel.alpha = 0
        currentTempLabel.alpha = 0
        tempUnitLabel.alpha = 0
        descriptionLabel.alpha = 0
        self.FirstDayLabel.alpha = 0
        self.SecondDayLabel.alpha = 0
        self.ThirdDayLabel.alpha = 0
        self.FourthDayLabel.alpha = 0
        self.FifthDayLabel.alpha = 0
        self.FirstIconImageView.alpha = 0
        self.SecondIconImageView.alpha = 0
        self.ThirdIconImageView.alpha = 0
        self.FourthIconImageView.alpha = 0
        self.FifthIconImageView.alpha = 0
        self.FirstTempLabel.alpha = 0
        self.SecondTempLabel.alpha = 0
        self.ThirdTempLabel.alpha = 0
        self.FourthTempLabel.alpha = 0
        self.FifthTempLabel.alpha = 0
        self.currentLocationButton.alpha = 0
        self.menuButton.alpha = 0
        self.historyButton.alpha = 0
    }
    
    func arrowAnimationStart(){
        
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.leftButton.alpha = 1
                self.rightButton.alpha = 1
                self.upButton.alpha = 1
                self.downButton.alpha = 1

                }) { (Bool) -> Void in

                    UIView.animateWithDuration(1.5, animations: { () -> Void in
                        self.leftButton.alpha = 0
                        self.rightButton.alpha = 0
                        self.upButton.alpha = 0
                        self.downButton.alpha = 0
                        }, completion: nil)
            }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) -> Void in
            if error != nil{
                print("Updating location Error")
            }else{
                let pm = placemarks![0] as CLPlacemark
                DataStruct.longitude = locValue.longitude
                DataStruct.latitude = locValue.latitude
                print(DataStruct.latitude,"    ", DataStruct.longitude)
                self.storeCurrentLocation(pm)
            }
        }
    }
    
    func storeCurrentLocation(pm: CLPlacemark){
        DataStruct.city = pm.locality!
        DataStruct.state = pm.administrativeArea!
        locationManager.stopUpdatingLocation()
        
        if haveCurrentLocation != true{
            let thisUrl = createURL()
            self.getJSON(thisUrl)
        }
        haveCurrentLocation = true
    }
    
    func createURL() -> NSURL{
        let urlStringBase = "http://huiyuanr-env.elasticbeanstalk.com/?"
        let urlStringArg = "latitude=\(DataStruct.latitude)&longtitude=\(DataStruct.longitude)&degree=" + (DataStruct.fahrenheit == true ? "fahrenheit" : "si")
        let url = NSURL(string: urlStringBase + urlStringArg.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
        return url!
    }
    
    func getJSON(url: NSURL){
        self.view.userInteractionEnabled = false
        self.spinerImageView.hidden = false
    
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    DataStruct.jsonfile = JSON(value)
                self.showWeatherAnimation()
                }
                break
            case .Failure:
                print("Request JSON Failure")
                break
            }
            self.spinerImageView.hidden = true
            
        }
    }
    
    func showWeatherAnimation(){
        setWeatherInfo()
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.weatherAppLabel.transform = CGAffineTransformMakeTranslation(0, -self.distance)
            self.currentLocationButton.alpha = 1
            self.menuButton.alpha = 1
            self.historyButton.alpha = 1
            
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.currentWeatherImageView.alpha = 1
                    }, completion: nil)
                UIView.animateWithDuration(0.2, delay: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.descriptionLabel.alpha = 1
                    }, completion: nil)
                UIView.animateWithDuration(0.2, delay: 0.2, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.currentTempLabel.alpha = 1
                    self.tempUnitLabel.alpha = 1
                    }, completion: nil)
                UIView.animateWithDuration(0.2, delay: 0.3, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                     self.lowHighTempLabel.alpha = 1
                    }) { (Bool) -> Void in
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            self.FirstDayLabel.alpha = 1
                            self.SecondDayLabel.alpha = 1
                            self.ThirdDayLabel.alpha = 1
                            self.FourthDayLabel.alpha = 1
                            self.FifthDayLabel.alpha = 1
                            self.FirstIconImageView.alpha = 1
                            self.SecondIconImageView.alpha = 1
                            self.ThirdIconImageView.alpha = 1
                            self.FourthIconImageView.alpha = 1
                            self.FifthIconImageView.alpha = 1
                            self.FirstTempLabel.alpha = 1
                            self.SecondTempLabel.alpha = 1
                            self.ThirdTempLabel.alpha = 1
                            self.FourthTempLabel.alpha = 1
                            self.FifthTempLabel.alpha = 1
                            
                        })
                        self.view.userInteractionEnabled = true
                        self.arrowAnimation = true
                        self.arrowAnimationStart()
                }
                
        }
    }
    
    func setWeatherInfo(){
        currentTempLabel.text = "\(DataStruct.jsonfile["currently"]["temperature"] != nil ?DataStruct.jsonfile["currently"]["temperature"].int! : DataStruct.errorInt)"
        currentWeatherImageView.image = UIImage(named: (DataStruct.jsonfile["currently"]["icon"] != nil ? DataStruct.jsonfile["currently"]["icon"].string! : DataStruct.errorString))
        descriptionLabel.text = (DataStruct.jsonfile["currently"]["summary"] != nil ? DataStruct.jsonfile["currently"]["summary"].string! : DataStruct.errorString) + " in " + DataStruct.city + ", " + DataStruct.state
        lowHighTempLabel.text = "L: " + "\(DataStruct.jsonfile["daily"]["data"][0]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][0]["temperatureMin"].int! : DataStruct.errorInt)" + "° | H: " + "\(DataStruct.jsonfile["daily"]["data"][0]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][0]["temperatureMax"].int! : DataStruct.errorInt)" + "°"
        tempUnitLabel.text = DataStruct.fahrenheit ? "℉":"℃"

        let firstDay = (DataStruct.jsonfile["daily"]["data"][1]["time"] != nil) ? (DataStruct.jsonfile["daily"]["data"][1]["time"].string!.characters.split{$0 == " "}.map(String.init)[0]) : DataStruct.errorString
        let secondDay = (DataStruct.jsonfile["daily"]["data"][2]["time"] != nil) ? (DataStruct.jsonfile["daily"]["data"][2]["time"].string!.characters.split{$0 == " "}.map(String.init)[0]) : DataStruct.errorString
        let thirdDay = (DataStruct.jsonfile["daily"]["data"][3]["time"] != nil) ? (DataStruct.jsonfile["daily"]["data"][3]["time"].string!.characters.split{$0 == " "}.map(String.init)[0]) : DataStruct.errorString
        let fourthDay = (DataStruct.jsonfile["daily"]["data"][4]["time"] != nil) ? (DataStruct.jsonfile["daily"]["data"][4]["time"].string!.characters.split{$0 == " "}.map(String.init)[0]) : DataStruct.errorString
        let fifthDay = (DataStruct.jsonfile["daily"]["data"][5]["time"] != nil) ? (DataStruct.jsonfile["daily"]["data"][5]["time"].string!.characters.split{$0 == " "}.map(String.init)[0]) : DataStruct.errorString
        FirstDayLabel.text = firstDay
        SecondDayLabel.text = secondDay
        ThirdDayLabel.text = thirdDay
        FourthDayLabel.text = fourthDay
        FifthDayLabel.text = fifthDay

        FirstIconImageView.image = UIImage(named: DataStruct.jsonfile["daily"]["data"][1]["icon"].string! ?? DataStruct.errorString)
        SecondIconImageView.image = UIImage(named: DataStruct.jsonfile["daily"]["data"][2]["icon"].string! ?? DataStruct.errorString)
        ThirdIconImageView.image = UIImage(named: DataStruct.jsonfile["daily"]["data"][3]["icon"].string! ?? DataStruct.errorString)
        FourthIconImageView.image = UIImage(named: DataStruct.jsonfile["daily"]["data"][4]["icon"].string! ?? DataStruct.errorString)
        FifthIconImageView.image = UIImage(named: DataStruct.jsonfile["daily"]["data"][5]["icon"].string! ?? DataStruct.errorString)
        
        FirstTempLabel.text = "L: " + "\(DataStruct.jsonfile["daily"]["data"][1]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][1]["temperatureMin"].int! : DataStruct.errorInt)" + "° | H: " + "\(DataStruct.jsonfile["daily"]["data"][1]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][1]["temperatureMax"].int! : DataStruct.errorInt)" + "°"
        SecondTempLabel.text = "L: " + "\(DataStruct.jsonfile["daily"]["data"][2]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][2]["temperatureMin"].int! : DataStruct.errorInt)" + "° | H: " + "\(DataStruct.jsonfile["daily"]["data"][2]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][2]["temperatureMax"].int! : DataStruct.errorInt)" + "°"
        ThirdTempLabel.text = "L: " + "\(DataStruct.jsonfile["daily"]["data"][3]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][3]["temperatureMin"].int! : DataStruct.errorInt)" + "° | H: " + "\(DataStruct.jsonfile["daily"]["data"][3]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][3]["temperatureMax"].int! : DataStruct.errorInt)" + "°"
        FourthTempLabel.text = "L: " + "\(DataStruct.jsonfile["daily"]["data"][4]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][4]["temperatureMin"].int! : DataStruct.errorInt)" + "° | H: " + "\(DataStruct.jsonfile["daily"]["data"][4]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][4]["temperatureMax"].int! : DataStruct.errorInt)" + "°"
        FifthTempLabel.text = "L: " + "\(DataStruct.jsonfile["daily"]["data"][5]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][5]["temperatureMin"].int! : DataStruct.errorInt)" + "° | H: " + "\(DataStruct.jsonfile["daily"]["data"][5]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][5]["temperatureMax"].int! : DataStruct.errorInt)" + "°"
    }
    
    func moveEveryThing(x: CGFloat, y :CGFloat){
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.weatherAppLabel.transform = CGAffineTransformTranslate(self.weatherAppLabel.transform, x * self.view.bounds.width, y * self.view.bounds.height)
            self.backGroundImageView.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.arrowAnimation = false
            self.currentWeatherImageView.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.lowHighTempLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.currentTempLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.tempUnitLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.descriptionLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.FirstDayLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.SecondDayLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.ThirdDayLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.FourthDayLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.FifthDayLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.FirstIconImageView.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.SecondIconImageView.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.ThirdIconImageView.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.FourthIconImageView.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.FifthIconImageView.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.FirstTempLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.SecondTempLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.ThirdTempLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.FourthTempLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.FifthTempLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.currentLocationButton.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.menuButton.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.historyButton.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            
            }, completion: nil)

    }
    
    func everythingGetBackToOriginPosition(){
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.weatherAppLabel.transform = CGAffineTransformMakeTranslation(0, -self.distance)
            self.backGroundImageView.transform = CGAffineTransformMakeTranslation(0,0)
            self.arrowAnimation = false
            self.currentWeatherImageView.transform = CGAffineTransformMakeTranslation(0,0)
            self.lowHighTempLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.currentTempLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.tempUnitLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.descriptionLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.FirstDayLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.SecondDayLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.ThirdDayLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.FourthDayLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.FifthDayLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.FirstIconImageView.transform = CGAffineTransformMakeTranslation(0,0)
            self.SecondIconImageView.transform = CGAffineTransformMakeTranslation(0,0)
            self.ThirdIconImageView.transform = CGAffineTransformMakeTranslation(0,0)
            self.FourthIconImageView.transform = CGAffineTransformMakeTranslation(0,0)
            self.FifthIconImageView.transform = CGAffineTransformMakeTranslation(0,0)
            self.FirstTempLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.SecondTempLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.ThirdTempLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.FourthTempLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.FifthTempLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.currentLocationButton.transform = CGAffineTransformMakeTranslation(0,0)
            self.menuButton.transform = CGAffineTransformMakeTranslation(0,0)
            self.historyButton.transform = CGAffineTransformMakeTranslation(0,0)
            
            }){(Bool) -> Void in
                self.arrowAnimation = true
                self.arrowAnimationStart()
        }
    }

    @IBAction func swipeUp(sender: UISwipeGestureRecognizer) {
        self.performSegueWithIdentifier("swipeUpSegue", sender: self)
        moveEveryThing(0, y: -1 )
            }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        self.performSegueWithIdentifier("swipeRightSegue", sender: self)
        moveEveryThing(1, y: 0 )

    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        self.performSegueWithIdentifier("swipeLeftSegue", sender: self)
        moveEveryThing(-1, y: 0 )
    }
    
    @IBAction func swipeDown(sender: UISwipeGestureRecognizer) {
        self.performSegueWithIdentifier("swipeDownSegue", sender: self)
        moveEveryThing(0, y: 1)
    }

    @IBAction func getCurrentLocationWeather(sender: UIButton) {
        self.haveCurrentLocation = false
        self.locationManager.startUpdatingLocation()
    }
    @IBAction func menuButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showMenuSegue", sender: self)

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "swipeUpSegue" {
            let des = segue.destinationViewController as! TodayTableViewController
            des.beforeViewController = self
        }
        else if segue.identifier == "swipeRightSegue"{
            let des = segue.destinationViewController as! Next24HoursViewController
            des.beforeViewController = self
        }
        else if segue.identifier == "swipeLeftSegue"{
            let des = segue.destinationViewController as! Next7DaysViewController
            des.beforeViewController = self
        }
        else if segue.identifier == "swipeDownSegue"{
            let des = segue.destinationViewController as! SearchViewController
            des.beforeViewController = self
        }
        else if segue.identifier == "showMenuSegue" {
            let des = segue.destinationViewController as! MenuViewController
            des.beforeViewController = self
        }
        
    }
    
}

