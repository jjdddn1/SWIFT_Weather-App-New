//
//  Next24HoursTableViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/13.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//


import UIKit
import SwiftyJSON
import Alamofire

class Next24HoursTableViewController: UITableViewController {
    var count = 0
    var numShow = 24
    
    var beforeViewController : WelcomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numShow = 24
        self.tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        setUpUI()

    }
    
    func setUpUI(){
        self.tableView.transform = CGAffineTransformMakeTranslation(-self.view.bounds.width, 0)
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.tableView.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: nil)
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(numShow == 24){
            return 2
        }else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 1){
            return 1
        }
        return numShow
    }
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cellPull = tableView.dequeueReusableCellWithIdentifier("PullUpTSMCell", forIndexPath: indexPath)
            cellPull.backgroundColor = UIColor.clearColor()
            return cellPull
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("oneCell", forIndexPath: indexPath) as! Next24HoursTableViewCell
            cell.backgroundColor = UIColor.clearColor()
        cell.data = indexPath.row
        
        
        //Configure the cell...
        return cell
    }
    

    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let x : CGFloat = 100
        let offset = (self.tableView.contentSize.height - self.tableView.frame.size.height + x) > 0 ? (self.tableView.contentSize.height - self.tableView.frame.size.height + x) : 0
        if (self.tableView.contentOffset.y >= offset) //x是触发操作的阀值
        {
            
            self.numShow = 48
            self.tableView.reloadData()
        }else if (self.tableView.contentOffset.x >= 50) //x是触发操作的阀值
        {
            viewDisappear()
        }

    }
    
    
    func viewDisappear(){
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.tableView.transform = CGAffineTransformMakeTranslation(-self.view.bounds.width, 0)
            self.beforeViewController.everythingGetBackToOriginPosition()
            }){(Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: nil)
                
        }
        
    }
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
