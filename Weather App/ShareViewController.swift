//
//  ShareViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/14.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import Social
import MessageUI

class ShareViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    var beforeViewController : MenuViewController!
    
    @IBOutlet var FBButton: UIButton!
    @IBOutlet var TTButton: UIButton!
    @IBOutlet var SMSButton: UIButton!
    @IBOutlet var EMButton: UIButton!
    @IBOutlet var WBButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //text position
        FBButton.contentHorizontalAlignment = .Left
        FBButton.contentEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0)
        TTButton.contentHorizontalAlignment = .Left
        TTButton.contentEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0)
        SMSButton.contentHorizontalAlignment = .Left
        SMSButton.contentEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0)
        EMButton.contentHorizontalAlignment = .Left
        EMButton.contentEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0)
        WBButton.contentHorizontalAlignment = .Left
        WBButton.contentEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true,completion:  nil )
        DataStruct.enterShare = false
        self.beforeViewController.shrinkMenu()
    }

    @IBAction func FBButtonPress(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.addImage(UIImage(named: "Weather_icon.png")!)
            facebookSheet.setInitialText("Check Swift Weather out! It help you to get current & future weather with all you need!\nhttps://itunes.apple.com/us/app/swift-weather-app-help-you/id1093067051?l=zh&ls=1&mt=8")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func TTButtonPress(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.addImage(UIImage(named: "Weather_icon.png")!)
            twitterSheet.setInitialText("Check Swift Weather out! It help you to get current & future weather with all you need!\nhttps://itunes.apple.com/us/app/swift-weather-app-help-you/id1093067051?l=zh&ls=1&mt=8")
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func weiboBTPress(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeSinaWeibo){
            let weiboSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
            weiboSheet.addImage(UIImage(named: "Weather_icon.png")!)
            weiboSheet.setInitialText("Check Swift Weather out! It help you to get current & future weather with all you need!\nhttps://itunes.apple.com/us/app/swift-weather-app-help-you/id1093067051?l=zh&ls=1&mt=8")
            self.presentViewController(weiboSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a SinaWeibo account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func SMSBTPress(sender: AnyObject) {
        sendMessage()
    }
    
    func sendMessage() {
        let messageViewC = MFMessageComposeViewController()
        messageViewC.body = "Check Swift Weather out! It help you to get current & future weather with all you need!\nhttps://itunes.apple.com/us/app/swift-weather-app-help-you/id1093067051?l=zh&ls=1&mt=8"
        messageViewC.recipients = [] // Optionally add some tel numbers
        messageViewC.messageComposeDelegate = self
        // Open the SMS View controller
        presentViewController(messageViewC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResultCancelled.rawValue :
            print("message canceled")
            
        case MessageComposeResultFailed.rawValue :
            print("message failed")
            
        case MessageComposeResultSent.rawValue :
            print("message sent")
            
        default:
            break
        }
//        self.view.hidden = true
        self.navigationController?.navigationBarHidden = true
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func EMBTPress(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([])
        mailComposerVC.setSubject("Check Swift Weather out!")
        mailComposerVC.setMessageBody("Check Swift Weather out! It help you to get current & future weather with all you need!\nhttps://itunes.apple.com/us/app/swift-weather-app-help-you/id1093067051?l=zh&ls=1&mt=8", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message: "Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
//        self.view.hidden = true
        self.navigationController?.navigationBarHidden = true
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        backButtonPressed(UIButton())
    }
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        backButtonPressed(UIButton())
    }

}
