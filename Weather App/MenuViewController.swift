//
//  MenuViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/14.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

import MessageUI

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    var beforeViewController: WelcomeViewController!

    @IBOutlet weak var tableView: UITableView!
    
    var location = CGPoint (x: 0, y: 0)
    var originLocation = CGPoint (x: 0, y: 0)
    var offsetX : CGFloat = 0
    var offsetY : CGFloat = 0
    var touchInSide = false
    var tableViewOriginFrame : CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.transform = CGAffineTransformMakeTranslation(-self.tableView.frame.width, 0)
        
        self.tableView.layer.shadowColor = UIColor.darkGrayColor().CGColor;//shadowColor阴影颜色
        self.tableView.layer.shadowOffset = CGSizeMake(4,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.tableView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        self.tableView.layer.shadowRadius = 5;//阴影半径，默认3
        self.tableView.clipsToBounds = false // 不屏蔽阴影
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.tableView.transform = CGAffineTransformMakeTranslation(0, 0)
            self.beforeViewController.view.transform = CGAffineTransformMakeTranslation(self.tableView.frame.width / 2 , 0)
            self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
        }
        tableViewOriginFrame = tableView.frame

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = DataStruct.fahrenheit ? "Unit: Fahrenheit" : "Unit: Celsius"
            break
        case 1:
            cell.textLabel?.text = "Send Feedback"
            break
        case 2:
            cell.textLabel?.text = "Share"
            break
        case 3:
            cell.textLabel?.text = "Rate me in App Store"
        case 4:
            cell.textLabel?.text = "About"
        default:
            break
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            if(DataStruct.fahrenheit){
                DataStruct.fahrenheit = !DataStruct.fahrenheit
                cell?.textLabel?.text = "Unit: Celsius"
            }else{
                DataStruct.fahrenheit = !DataStruct.fahrenheit
                cell?.textLabel?.text = "Unit: Fahrenheit"
            }
            beforeViewController.getCurrentLocationWeather(UIButton())
            break
        case 1:
            sendFeedback()
            break
        case 2:
            enlargeMenu("shareSegue")
            break
        case 3:
            if let requestUrl = NSURL(string: "https://itunes.apple.com/us/app/swift-weather-app-help-you/id1093067051?l=zh&ls=1&mt=8") {
                UIApplication.sharedApplication().openURL(requestUrl)
            }
            break
        case 4:
            enlargeMenu("aboutSegue")
            break
        default:
            break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        cell!.contentView.backgroundColor = UIColor.grayColor()
        
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        cell!.contentView.backgroundColor = UIColor.whiteColor()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }


    func sendFeedback() {
        let Subject = "Feedback for Weather App"
        let toRecipients = ["huiyuanr@usc.edu"]
        let mc : MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(Subject)
        mc.setToRecipients(toRecipients)
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mc, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func showSendMailErrorAlert() {
      
            let alert = UIAlertController(title: "Could Not Send Email", message: "Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            NSLog("Mail Cancelled")
        case MFMailComposeResultFailed.rawValue:
            NSLog("Mail sent failure: %@",[error!.localizedDescription])
        case MFMailComposeResultSaved.rawValue:
            NSLog("Mail Saved")
        case MFMailComposeResultSent.rawValue:
            NSLog("Mail Sent")
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func enlargeMenu(segueName :String ){
        self.view.userInteractionEnabled = false
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.tableView.frame = self.view.frame
            DataStruct.enterShare = true
            }) { (Bool) -> Void in
                self.performSegueWithIdentifier(segueName, sender: self)
                self.view.userInteractionEnabled = true
        }
    }
    func shrinkMenu(){
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.tableView.frame = self.tableViewOriginFrame
            }) { (Bool) -> Void in
        }
    }
    
    
    func CancelButtonPressed(sender: UIButton) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor
            self.tableView.transform = CGAffineTransformMakeTranslation(-self.tableView.frame.width, 0)
            self.beforeViewController.view.transform = CGAffineTransformMakeTranslation(0 , 0)
            }) { (Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: nil)
        }
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !DataStruct.enterShare {
            let touch : UITouch! = touches.first
            originLocation = touch.locationInView(self.view)
            touchInSide = true
        }
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !DataStruct.enterShare{
            let touch : UITouch! = touches.first
            self.location = touch.locationInView(self.view)
            offsetX = location.x - originLocation.x
            offsetY = location.y - originLocation.y
            if abs(offsetX) > 10 || abs(offsetY) > 10 {
                touchInSide = false
            }
            
            if offsetX > 0 {
                offsetX = 0
            }
            self.tableView.transform = CGAffineTransformMakeTranslation(offsetX, 0)
            self.beforeViewController.view.transform = CGAffineTransformMakeTranslation(self.tableView.frame.width / 2 + offsetX / 2 , 0)
            self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3 + offsetX / self.tableView.frame.width * 0.3 ).CGColor
            
        }
        //            print(location.x + offsetX)
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !DataStruct.enterShare{
            let maxOffset = self.tableView.frame.width / 4
            if(offsetX > -maxOffset && touchInSide == false){
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.tableView.transform = CGAffineTransformMakeTranslation(0, 0)
                    self.beforeViewController.view.transform = CGAffineTransformMakeTranslation(self.tableView.frame.width / 2 , 0)
                    self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
                    }) { (Bool) -> Void in
                }
            }else if (touchInSide == true){
                CancelButtonPressed(UIButton())
            }else{
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.tableView.transform = CGAffineTransformMakeTranslation(-self.tableView.frame.width, 0)
                    self.beforeViewController.view.transform = CGAffineTransformMakeTranslation(0 , 0)
                    self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor
                    
                    }) { (Bool) -> Void in
                        self.dismissViewControllerAnimated(false, completion: nil)
                }
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "shareSegue"{
            let des = segue.destinationViewController as! ShareViewController
            des.beforeViewController = self
        }else if segue.identifier == "aboutSegue"{
            let des = segue.destinationViewController as! AboutViewController
            des.beforeViewController = self
        }
        
    }


}
