//
//  AboutViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/14.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    var beforeViewController : MenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    @IBAction func foreCastButtonPressed(sender: UIButton) {
        if let url = NSURL(string: "http://forecast.io/") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        backButtonPressed(UIButton())
    }
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        backButtonPressed(UIButton())
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
