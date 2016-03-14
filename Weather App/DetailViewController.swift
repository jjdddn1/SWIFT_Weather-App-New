//
//  DetailViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/13.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate{

    var tableViewController : DetailTableViewController? = nil
    var beforeViewController: Next7DaysViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        createTable()
    }

    func createTable(){
        tableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailTable") as? DetailTableViewController
        self.tableViewController!.view.frame = CGRectMake(10, 250, UIScreen.mainScreen().bounds.width - 20, self.view.frame.maxY - 260)
        self.addChildViewController(self.tableViewController!)
        self.view.addSubview(self.tableViewController!.view)
        self.tableViewController!.didMoveToParentViewController(self)
    }

    
    @IBAction func backButtonPressed(sender: UIButton) {
        beforeViewController.everythingGetBackToOrigin()
        self.dismissViewControllerAnimated(true, completion: nil)
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
