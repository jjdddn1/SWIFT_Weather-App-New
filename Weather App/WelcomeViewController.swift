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
    
    @IBOutlet weak var FirstIconImageView: UIImageView!
    @IBOutlet weak var SecondIconImageView: UIImageView!
    @IBOutlet weak var ThirdIconImageView: UIImageView!
    
    @IBOutlet weak var FirstTempLabel: UILabel!
    @IBOutlet weak var SecondTempLabel: UILabel!
    @IBOutlet weak var ThirdTempLabel: UILabel!
    
    var haveCurrentLocation = false
    let locationManager = CLLocationManager()
    
    var arrowAnimation = false

    
    var distance : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        backGroundImageView.image = UIImage(named:"4244272-night.jpg")

        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        setUpUI()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.FirstIconImageView.alpha = 0
        self.SecondIconImageView.alpha = 0
        self.ThirdIconImageView.alpha = 0
        self.FirstTempLabel.alpha = 0
        self.SecondTempLabel.alpha = 0
        self.ThirdTempLabel.alpha = 0
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
            self.getJSON()
        }
        haveCurrentLocation = true
    }
    
    func getJSON(){
        let urlStringBase = "http://huiyuanr-env.elasticbeanstalk.com/?"
        let urlStringArg = "latitude=\(DataStruct.latitude)&longtitude=\(DataStruct.longitude)&degree=" + (DataStruct.fahrenheit == true ? "ui" : "si")
        let url = NSURL(string: urlStringBase + urlStringArg.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!)
        print("URL:" , url)
        print("Start Requesting JSON")
        Alamofire.request(.GET, url!).validate().responseJSON { response in
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
            
        }
    }
    
    func showWeatherAnimation(){
        setWeatherInfo()
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
             self.distance = self.weatherAppLabel.center.y -  self.upButton.center.y - 70
            self.weatherAppLabel.transform = CGAffineTransformMakeTranslation(0, -self.distance)
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
                            self.FirstIconImageView.alpha = 1
                            self.SecondIconImageView.alpha = 1
                            self.ThirdIconImageView.alpha = 1
                            self.FirstTempLabel.alpha = 1
                            self.SecondTempLabel.alpha = 1
                            self.ThirdTempLabel.alpha = 1
                        })
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
        FirstDayLabel.text = firstDay
        SecondDayLabel.text = secondDay
        ThirdDayLabel.text = thirdDay
        
        FirstIconImageView.image = UIImage(named: DataStruct.jsonfile["daily"]["data"][1]["icon"].string! ?? DataStruct.errorString)
        SecondIconImageView.image = UIImage(named: DataStruct.jsonfile["daily"]["data"][2]["icon"].string! ?? DataStruct.errorString)
        ThirdIconImageView.image = UIImage(named: DataStruct.jsonfile["daily"]["data"][3]["icon"].string! ?? DataStruct.errorString)
        
        FirstTempLabel.text = "L: " + "\(DataStruct.jsonfile["daily"]["data"][1]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][1]["temperatureMin"].int! : DataStruct.errorInt)" + "° | H: " + "\(DataStruct.jsonfile["daily"]["data"][1]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][1]["temperatureMax"].int! : DataStruct.errorInt)" + "°"
        SecondTempLabel.text = "L: " + "\(DataStruct.jsonfile["daily"]["data"][2]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][2]["temperatureMin"].int! : DataStruct.errorInt)" + "° | H: " + "\(DataStruct.jsonfile["daily"]["data"][2]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][2]["temperatureMax"].int! : DataStruct.errorInt)" + "°"
        ThirdTempLabel.text = "L: " + "\(DataStruct.jsonfile["daily"]["data"][3]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][3]["temperatureMin"].int! : DataStruct.errorInt)" + "° | H: " + "\(DataStruct.jsonfile["daily"]["data"][3]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][3]["temperatureMax"].int! : DataStruct.errorInt)" + "°"
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
            self.FirstIconImageView.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.SecondIconImageView.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.ThirdIconImageView.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.FirstTempLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.SecondTempLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            self.ThirdTempLabel.transform = CGAffineTransformMakeTranslation(x * self.view.bounds.width, y * self.view.bounds.height)
            
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
            self.FirstIconImageView.transform = CGAffineTransformMakeTranslation(0,0)
            self.SecondIconImageView.transform = CGAffineTransformMakeTranslation(0,0)
            self.ThirdIconImageView.transform = CGAffineTransformMakeTranslation(0,0)
            self.FirstTempLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.SecondTempLabel.transform = CGAffineTransformMakeTranslation(0,0)
            self.ThirdTempLabel.transform = CGAffineTransformMakeTranslation(0,0)
            
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
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.backGroundImageView.transform = CGAffineTransformMakeTranslation(-self.view.bounds.width, 0)
            }, completion: nil)
    }
    
    @IBAction func swipeDown(sender: UISwipeGestureRecognizer) {
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.backGroundImageView.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height)
            }, completion: nil)
    }
    

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "swipeUpSegue" {
            let des = segue.destinationViewController as! TodayTableViewController
            des.beforeViewController = self
        }
        if segue.identifier == "swipeRightSegue"{
            let des = segue.destinationViewController as! Next24HoursTableViewController
            des.beforeViewController = self
        }
    }
    
}

