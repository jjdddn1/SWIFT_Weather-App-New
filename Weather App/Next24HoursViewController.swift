//
//  Next24HoursViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/13.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class Next24HoursViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var beforeViewController : WelcomeViewController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var TitleLabel: UILabel!

    var numShow = 24

    
    override func viewDidLoad() {
        super.viewDidLoad()
        numShow = 24
        TitleLabel.text = "Next \(numShow) Hours Weather"
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
        self.view.transform = CGAffineTransformMakeTranslation(-self.view.bounds.width, 0)
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: nil)
    }
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if(numShow == 24){
            return 2
        }else{
            return 1
        }
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 1){
            return 1
        }
        return numShow
    }
    
    
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
    
    
     func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        
    }
    
     func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let x : CGFloat = 100
        let offset = (self.tableView.contentSize.height - self.tableView.frame.size.height + x) > 0 ? (self.tableView.contentSize.height - self.tableView.frame.size.height + x) : 0
        if (self.tableView.contentOffset.y >= offset) //x是触发操作的阀值
        {
            
            self.numShow = 48
            self.TitleLabel.text = "Next \(numShow) Hours Weather"
            self.tableView.reloadData()
        }else if (self.tableView.contentOffset.x >= 50) //x是触发操作的阀值
        {
            viewDisappear()
        }
        
    }
    
    
    func viewDisappear(){
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view.transform = CGAffineTransformMakeTranslation(-self.view.bounds.width, 0)
            self.beforeViewController.everythingGetBackToOriginPosition()
            }){(Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: nil)
                
        }
        
    }



}
