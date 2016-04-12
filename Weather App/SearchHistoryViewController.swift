//
//  SearchHistoryViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/4/11.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import Spring

class SearchHistoryViewController: UIViewController {
    


    @IBOutlet weak var NavBar: UIView!
    
    @IBOutlet weak var Button1: SpringButton!
    @IBOutlet weak var Button2: SpringButton!
    @IBOutlet weak var Button3: SpringButton!
    @IBOutlet weak var Button4: SpringButton!
    @IBOutlet weak var Button5: SpringButton!
    @IBOutlet weak var Button6: SpringButton!

    
    @IBOutlet weak var Delete1: UIButton!
    @IBOutlet weak var Delete2: UIButton!
    @IBOutlet weak var Delete3: UIButton!
    @IBOutlet weak var Delete4: UIButton!
    @IBOutlet weak var Delete5: UIButton!
    @IBOutlet weak var Delete6: UIButton!

    var buttonArray : [UIButton] = []
    var deleteArray : [UIButton] = []
    
    @IBOutlet weak var backGroundButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonArray = [Button1, Button2, Button3, Button4, Button5, Button6]
        deleteArray = [Delete1, Delete2, Delete3, Delete4, Delete5, Delete6]
        
        setUpUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {

    }
    
    override func viewWillAppear(animated: Bool) {
        UIView.animateWithDuration(0.4) {
            self.NavBar.transform = CGAffineTransformMakeTranslation(0,0)
        }
//        for del in deleteArray {
//            del.hidden = true
//            del.alpha = 0
//        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        let height = NavBar.frame.height
        UIView.animateWithDuration(0.3) {
            self.NavBar.transform = CGAffineTransformMakeTranslation(0,-height)
            for but in self.buttonArray {
                but.transform = CGAffineTransformMakeTranslation(0,100)
            }
            for del in self.deleteArray {
                del.transform = CGAffineTransformMakeTranslation(0,-100)

            }

        }
        
    }
    func setUpUI(){
        for but in buttonArray {
            but.layer.cornerRadius = 10
            but.layer.masksToBounds = true
        }

        for del in self.deleteArray {
            del.alpha = 0
        }
        let height = NavBar.frame.height
        NavBar.transform = CGAffineTransformMakeTranslation(0,-height)
    }
    
    @IBAction func backGroundButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(sender: UIButton) {
        let n = Int(sender.restorationIdentifier!)
        let distance = self.buttonArray[0].center.y - self.buttonArray[1].center.y
        for del in deleteArray {
            del.enabled = false
        }
        
        UIView.animateWithDuration(0.2, animations: {
            self.buttonArray[n!].transform = CGAffineTransformMakeTranslation(-100,0)
            self.deleteArray[n!].transform = CGAffineTransformMakeTranslation(-100,0)
            self.buttonArray[n!].alpha = 0
            self.deleteArray[n!].alpha = 0
            }) { (Bool) in
                
                self.buttonArray[n!].transform = CGAffineTransformMakeTranslation(0,0)
                self.buttonArray[n!].center = CGPoint(x: (self.buttonArray.last?.center.x)!, y: (self.buttonArray.last?.center.y)! - distance)
                self.buttonArray[n!].alpha = 0
                
                self.deleteArray[n!].transform = CGAffineTransformMakeTranslation(0,0)
                self.deleteArray[n!].center = CGPoint(x: (self.deleteArray.last?.center.x)!, y: (self.deleteArray.last?.center.y)! - distance)
                self.deleteArray[n!].alpha = 0
                
                
                UIView.animateWithDuration(0.2){
                    for i in (n! + 1) ..<  self.buttonArray.count {
                        self.buttonArray[i].center = CGPoint(x: self.buttonArray[i].center.x,y: self.buttonArray[i].center.y + distance)
                        self.deleteArray[i].center = CGPoint(x: self.deleteArray[i].center.x,y: self.deleteArray[i].center.y + distance)
                    }
                    self.buttonArray[n!].center = CGPoint(x: self.buttonArray[n!].center.x,y: self.buttonArray[n!].center.y + distance)
                    self.buttonArray[n!].alpha = 1
                    
                    self.deleteArray[n!].center = CGPoint(x: self.deleteArray[n!].center.x,y: self.deleteArray[n!].center.y + distance)
                    self.deleteArray[n!].alpha = 1

                }
                let button = self.buttonArray.removeAtIndex(n!)
                self.buttonArray.append(button)
                
                let delete = self.deleteArray.removeAtIndex(n!)
                self.deleteArray.append(delete)
                
                for i in 0 ..< self.deleteArray.count{
                    self.deleteArray[i].restorationIdentifier = "\(i)"
                    self.deleteArray[i].enabled = true
                }
        }
    }
    
    var userIsEditing = false
    @IBAction func editButtonPressed(sender: UIButton) {
        if(!userIsEditing){
            backGroundButton.enabled = false
            userIsEditing = true
            for button in buttonArray{
                button.enabled = false
            }

            var time = 0.0
            for del in self.deleteArray {
                del.hidden = false
                UIView.animateWithDuration(0.2, delay: time * 0.1 , options: UIViewAnimationOptions.CurveEaseInOut, animations:  {
                        del.alpha = 1
                    del.transform = CGAffineTransformRotate(del.transform, CGFloat(15 * M_PI))
                }, completion: nil )
                time = time + 1
            }
        }
        else{
            userIsEditing = false

            UIView.animateWithDuration(0.2, animations: {
                for del in self.deleteArray {
                    del.alpha = 0
                }
                }, completion: { (Bool) in
                    for del in self.deleteArray {
                        del.hidden = true
                        
                    }
                    self.backGroundButton.enabled = true
                    for button in self.buttonArray{
                        button.enabled = true
                    }
                    
            })

        }
        
        if(userIsEditing){
            self.editButton.setTitle("Edit", forState: UIControlState.Normal)
        }else{
            self.editButton.setTitle("Done", forState: UIControlState.Normal)
        }
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
