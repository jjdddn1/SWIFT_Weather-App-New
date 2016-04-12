//
//  DetailTableViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/13.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    @IBOutlet weak var precipitation: UILabel!
    @IBOutlet weak var chance_of_rain: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var dewPoint: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var visibility: UILabel!
    
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        setWeatherInfo()
        tableViewAnimationStart()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    /* Perfrom the animation loading the table */
    func tableViewAnimationStart(){
        let diff = 0.05
        let cells = tableView.visibleCells as [UITableViewCell]
        var tableHeight : CGFloat = 0
        for cell in cells{
            tableHeight -= cell.frame.size.height
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        for i in 0..<cells.count{
            
            let cell = cells[i] as UITableViewCell
            cell.layer.hidden = false
            
            let delay = diff * Double(i - 1)
            UIView.animateWithDuration(0.2, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations:{ () -> Void in
                cell.transform = CGAffineTransformMakeTranslation(0, 0)
                cell.alpha = 1
                }, completion : nil)
            
        }
    }
    
    func setWeatherInfo(){
        
        let val =  DataStruct.jsonfile["daily"]["data"][DataStruct.dayNum]["precipIntensity"] != nil ? DataStruct.jsonfile["daily"]["data"][DataStruct.dayNum]["precipIntensity"].double! : DataStruct.errorDouble
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
        
        let chanceofrain : Int = Int((DataStruct.jsonfile["daily"]["data"][DataStruct.dayNum]["precipProbability"] != nil ? DataStruct.jsonfile["daily"]["data"][DataStruct.dayNum]["precipProbability"].double! : DataStruct.errorDouble) * 100)
        self.chance_of_rain.text = "\(chanceofrain) %"
        
        self.windSpeed.text = "\(DataStruct.jsonfile["daily"]["data"][DataStruct.dayNum]["windSpeed"] != nil ? DataStruct.jsonfile["daily"]["data"][DataStruct.dayNum]["windSpeed"].double! : DataStruct.errorDouble) " + (DataStruct.fahrenheit ? "mph":"m/s")
        
        self.dewPoint.text = "\(DataStruct.jsonfile["daily"]["data"][DataStruct.dayNum]["dewPoint"] != nil ? DataStruct.jsonfile["daily"]["data"][DataStruct.dayNum]["dewPoint"].int! : DataStruct.errorInt) " + (DataStruct.fahrenheit ? "℉":"℃")
        
        self.humidity.text = "\(Int((DataStruct.jsonfile["daily"]["data"][DataStruct.dayNum]["humidity"] != nil ? DataStruct.jsonfile["daily"]["data"][DataStruct.dayNum]["humidity"].double! : DataStruct.errorDouble)*100)) %"
        
        self.visibility.text = "\(DataStruct.jsonfile["daily"]["data"][DataStruct.dayNum]["visibility"] != nil ? DataStruct.jsonfile["daily"]["data"][DataStruct.dayNum]["visibility"].double! : DataStruct.errorDouble) " +
            (DataStruct.fahrenheit ? "mi":"km")
        
        self.sunrise.text = DataStruct.jsonfile["daily"]["data"][0]["sunriseTime"] != nil ? DataStruct.jsonfile["daily"]["data"][0]["sunriseTime"].string! : DataStruct.errorString
        self.sunset.text = DataStruct.jsonfile["daily"]["data"][0]["sunsetTime"] != nil ? DataStruct.jsonfile["daily"]["data"][0]["sunsetTime"].string! : DataStruct.errorString
        
    }

    
    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
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
