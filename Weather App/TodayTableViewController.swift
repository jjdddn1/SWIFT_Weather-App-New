//
//  TodayTableViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/12.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class TodayTableViewController: UITableViewController {

    var beforeViewController: WelcomeViewController!
    
    @IBOutlet weak var tmperature: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var summary: UILabel!
    
    @IBOutlet weak var us: UILabel!
    
    @IBOutlet weak var precipitation: UILabel!
    @IBOutlet weak var LowHigh: UILabel!
    @IBOutlet weak var chance_of_rain: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var dewPoint: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var visibility: UILabel!
    
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWeatherInfo()
        
    }

    override func viewWillAppear(animated: Bool) {
        setUpUI()
    }
    
    func setWeatherInfo(){
        self.tmperature.text = "\(DataStruct.jsonfile["currently"]["temperature"] != nil ?DataStruct.jsonfile["currently"]["temperature"].int! : DataStruct.errorInt)"
        self.img.image = UIImage(named: (DataStruct.jsonfile["currently"]["icon"] != nil ? DataStruct.jsonfile["currently"]["icon"].string! : DataStruct.errorString))
        self.summary.text = (DataStruct.jsonfile["currently"]["summary"] != nil ? DataStruct.jsonfile["currently"]["summary"].string! : DataStruct.errorString) + " in " + DataStruct.city + ", " + DataStruct.state

        self.us.text = DataStruct.fahrenheit ? "℉":"℃"
        self.LowHigh.text = "L: " + "\(DataStruct.jsonfile["daily"]["data"][0]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][0]["temperatureMin"].int! : DataStruct.errorInt)" + "° | H: " + "\(DataStruct.jsonfile["daily"]["data"][0]["temperatureMin"] != nil ? DataStruct.jsonfile["daily"]["data"][0]["temperatureMax"].int! : DataStruct.errorInt)" + "°"
        
        let val =  DataStruct.jsonfile["currently"]["precipIntensity"] != nil ? DataStruct.jsonfile["currently"]["precipIntensity"].double! : DataStruct.errorDouble
        if(val >= 0 && val < 0.002){
            self.precipitation.text = "None"
        }else if(val >= 0.002 && val < 0.017){
            self.precipitation.text = "Very Light";
        }else if(val >= 0.017 && val < 0.1){
            self.precipitation.text = "Light";
        }else if(val >= 0.1 && val < 0.4){
            self.precipitation.text = "Moderate";
        }else if(val >= 0.4){
            self.precipitation.text = "Heavy";
        }else{
            self.precipitation.text = "INVALID VALUE";
        }
        
        let chanceofrain : Int = Int((DataStruct.jsonfile["currently"]["precipProbability"] != nil ? DataStruct.jsonfile["currently"]["precipProbability"].double! : DataStruct.errorDouble) * 100)
        self.chance_of_rain.text = "\(chanceofrain) %"
        
        self.windSpeed.text = "\(DataStruct.jsonfile["currently"]["windSpeed"] != nil ? DataStruct.jsonfile["currently"]["windSpeed"].double! : DataStruct.errorDouble) " + (DataStruct.fahrenheit ? "mph":"m/s")
        
        self.dewPoint.text = "\(DataStruct.jsonfile["currently"]["dewPoint"] != nil ? DataStruct.jsonfile["currently"]["dewPoint"].int! : DataStruct.errorInt) " + (DataStruct.fahrenheit ? "℉":"℃")
        
        self.humidity.text = "\(Int((DataStruct.jsonfile["currently"]["humidity"] != nil ? DataStruct.jsonfile["currently"]["humidity"].double! : DataStruct.errorDouble)*100)) %"
        
        self.visibility.text = "\(DataStruct.jsonfile["currently"]["visibility"] != nil ? DataStruct.jsonfile["currently"]["visibility"].double! : DataStruct.errorDouble) " +
            (DataStruct.fahrenheit ? "mi":"km")
        
        self.sunrise.text = DataStruct.jsonfile["daily"]["data"][0]["sunriseTime"] != nil ? DataStruct.jsonfile["daily"]["data"][0]["sunriseTime"].string! : DataStruct.errorString
        self.sunset.text = DataStruct.jsonfile["daily"]["data"][0]["sunsetTime"] != nil ? DataStruct.jsonfile["daily"]["data"][0]["sunsetTime"].string! : DataStruct.errorString

    }
    
    func setUpUI(){
        self.tableView.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height)
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.tableView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let x : CGFloat = 100

        if (self.tableView.contentOffset.y <=  -x) //x是触发操作的阀值
        {
            viewDisappear()
        }
    }
    
    
    func viewDisappear(){
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.tableView.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.height)
            self.beforeViewController.everythingGetBackToOriginPosition()
            }){(Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: nil)
        
        }

    }
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
