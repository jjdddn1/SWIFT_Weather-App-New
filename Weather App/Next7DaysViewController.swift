//
//  Next7DaysViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/13.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionCell"

class Next7DaysViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var beforeViewController : WelcomeViewController!

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpUI()
    }
    
    func setUpUI(){
        self.view!.transform = CGAffineTransformMakeTranslation(self.view.bounds.width, 0)
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view!.transform = CGAffineTransformMakeTranslation(0, 0)
            }, completion: nil)
    }
    
    func viewDisappear(){
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view!.transform = CGAffineTransformMakeTranslation(self.view.bounds.width, 0)
            self.beforeViewController.everythingGetBackToOriginPosition()
            }){(Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: nil)
                
        }
        
    }
    
    func everythingGetBackToOrigin(){
        self.collectionView.userInteractionEnabled = false
        
        UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.cellCache.center = self.center
            let cells = self.collectionView.visibleCells()
            for singleCell in cells {
                singleCell.alpha = 1
            }
            }) { (Bool) -> Void in
                self.collectionView.userInteractionEnabled = true
        }
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Next7DaysCollectionViewCell
            cell.layer.cornerRadius = 5
            let imageName = (DataStruct.jsonfile["daily"]["data"][indexPath.row + 1]["icon"].string! + "_bg.jpg") ?? DataStruct.errorString
            let img = UIImage(named:imageName)!
            cell.backgroundImageView.image = img
            cell.backgroundImageView.alpha = 0.9
            cell.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
            cell.time.text = (DataStruct.jsonfile["daily"]["data"][indexPath.row + 1]["time"].string! ?? DataStruct.errorString).stringByReplacingOccurrencesOfString("y ", withString: "y, ")
            cell.icon.image = UIImage(named: DataStruct.jsonfile["daily"]["data"][indexPath.row + 1]["icon"].string! ?? DataStruct.errorString)
        
            let tempL = DataStruct.jsonfile["daily"]["data"][indexPath.row + 1]["temperatureMin"].int! ?? DataStruct.errorInt
            let tempH = DataStruct.jsonfile["daily"]["data"][indexPath.row + 1]["temperatureMax"].int! ?? DataStruct.errorInt
            cell.temp.text = "Min: " + "\(tempL)" + (DataStruct.fahrenheit ? "℉" : "℃" ) + " | Max: " + "\(tempH)" + (DataStruct.fahrenheit ? "℉" : "℃" )
        
            cell.summary.text = (DataStruct.jsonfile["daily"]["data"][indexPath.row + 1]["summary"].string! ?? DataStruct.errorString)        
            return cell
       
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell  = collectionView.cellForItemAtIndexPath(indexPath) as! Next7DaysCollectionViewCell
        cell.backgroundImageView.alpha = 0.5
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell  = collectionView.cellForItemAtIndexPath(indexPath) as! Next7DaysCollectionViewCell
        cell.backgroundImageView.alpha = 0.9
    }
    
    var center : CGPoint!
    var cellCache : Next7DaysCollectionViewCell!

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        cellCache  = collectionView.cellForItemAtIndexPath(indexPath) as! Next7DaysCollectionViewCell
        center = cellCache.center
        self.collectionView.userInteractionEnabled = false
        DataStruct.dayNum = indexPath.row + 1
        UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.cellCache.center = CGPoint(x: self.center.x , y: 75 + self.collectionView.contentOffset.y )
            let cells = self.collectionView.visibleCells()
            for singleCell in cells {
                if singleCell != self.cellCache{
                    singleCell.alpha = 0
                }
            }
            }) { (Bool) -> Void in
                self.performSegueWithIdentifier("showDetailSegue", sender: self)

        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = CGSize(width: UIScreen.mainScreen().bounds.width - 20 , height: 150)
        return size
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (self.collectionView!.contentOffset.x <= -50) //x是触发操作的阀值
        {
            print("Gesture")
            viewDisappear()
        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailSegue"{
            let des = segue.destinationViewController as! DetailViewController
            des.beforeViewController = self
        }
    }


}
