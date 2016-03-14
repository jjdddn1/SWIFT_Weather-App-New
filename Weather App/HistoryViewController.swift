//
//  HistoryViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/13.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import CoreData


class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var beforeViewController: SearchViewController!
    var result : [NSManagedObject]! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSavedData()
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.hidden = true
        self.view.transform = CGAffineTransformMakeTranslation(self.view.bounds.width, 0)
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.view.transform = CGAffineTransformMakeTranslation(0,0)
            }) { (Bool) -> Void in
                self.tableViewAnimationStart()
        }
    }
    
    func tableViewAnimationStart(){
        self.tableView.hidden = false

        let diff = 0.05
        let cells = tableView.visibleCells as [UITableViewCell]
        var tableWidth : CGFloat = 0
        for cell in cells{
            tableWidth = cell.frame.size.width
            cell.transform = CGAffineTransformMakeTranslation(tableWidth, 0)
        }
        for i in 0..<cells.count{
            
            let cell = cells[i] as UITableViewCell
            cell.layer.hidden = false
            
            let delay = diff * Double(i - 1)
            UIView.animateWithDuration(0.3, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations:{ () -> Void in
                cell.transform = CGAffineTransformMakeTranslation(0, 0)
                cell.alpha = 1
                }, completion : nil)
            
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return result.count
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
 
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath)
        let item = result[indexPath.row]
        let cityName = item.valueForKey("city") as! String
        let stateName = item.valueForKey("state") as! String
        let streetName = item.valueForKey("street") as! String
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.text = streetName + ", " + cityName + ", " + stateName
        
        //Configure the cell...
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        beforeViewController.street.text = result[indexPath.row].valueForKey("street") as? String
        beforeViewController.city.text = result[indexPath.row].valueForKey("city") as? String
        let state = result[indexPath.row].valueForKey("state") as! String
        beforeViewController.selectState.setTitle("  \(state)", forState: UIControlState.Normal)
        viewDisappear()
    }

    
    func checkSavedData(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "History")
        do{
            result = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        }catch{
            print("Check Saved Data Error")
        }
    }
    
    func removeData(x: Int){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        if(x >= 0){
//        let fetchRequest = NSFetchRequest(entityName: "History")
//        let entity = NSEntityDescription.entityForName("QandA", inManagedObjectContext: managedContext)
            let item = result.removeAtIndex(x)
            
            managedContext.deleteObject(item)
        }else{
            for  item in result {
                managedContext.deleteObject(item)
                
            }
            result.removeAll()
        }
        do{
            try managedContext.save()

        }catch{
            print("Error")
        }
        
    }
    
    @IBAction func DeleteAllButtonPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: "Clean up search history", message: "Are you sure you want to delete all search history?", preferredStyle: .Alert)
        let confirm = UIAlertAction(title: "Continue", style: .Default) { (_) -> Void in
            self.removeData(-1)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(cancel)
        alertController.addAction(confirm)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            removeData(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    
    func viewDisappear(){
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.view!.transform = CGAffineTransformMakeTranslation(self.view.bounds.width, 0)
            self.beforeViewController.everythingGetBackToOriginPosition()
            }){(Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: nil)
                
        }
        
    }
    @IBAction func backButtonPressed(sender: UIButton) {
        viewDisappear()
    }
    var firstTime = true
    @IBAction func swipeFromLeftEdge(sender: UIScreenEdgePanGestureRecognizer) {
        if firstTime{
            viewDisappear()
            firstTime = false
        }
    }
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        if (self.tableView!.contentOffset.x <= -50) //x是触发操作的阀值
//        {
//            print("Gesture")
//            viewDisappear()
//        }
//        
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
