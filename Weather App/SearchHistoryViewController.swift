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
    
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button4: UIButton!
    @IBOutlet weak var Button5: UIButton!
    @IBOutlet weak var Button6: UIButton!

    
    @IBOutlet weak var Delete1: UIButton!
    @IBOutlet weak var Delete2: UIButton!
    @IBOutlet weak var Delete3: UIButton!
    @IBOutlet weak var Delete4: UIButton!
    @IBOutlet weak var Delete5: UIButton!
    @IBOutlet weak var Delete6: UIButton!

    @IBOutlet weak var View1: SpringView!
    @IBOutlet weak var View2: SpringView!
    @IBOutlet weak var View3: SpringView!
    @IBOutlet weak var View4: SpringView!
    @IBOutlet weak var View5: SpringView!
    @IBOutlet weak var View6: SpringView!

    var buttonArray : [UIButton] = []
    var deleteArray : [UIButton] = []
    var buttonPosition: [Int] = []
    var viewArray: [UIView] = []
    
    @IBOutlet weak var backGroundButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var distance :CGFloat = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        distance = self.viewArray[0].center.y - self.viewArray[1].center.y
        
    }
    
    override func viewWillAppear(animated: Bool) {
        deleteArray = [Delete1, Delete2, Delete3, Delete4, Delete5, Delete6]
        buttonArray = [Button1, Button2, Button3, Button4, Button5, Button6]
        viewArray = [View1,View2,View3, View4, View5, View6]

        buttonPosition = [0,1,2,3,4,5]
        setUpUI()
        
        UIView.animateWithDuration(0.4) {
            self.NavBar.transform = CGAffineTransformMakeTranslation(0,0)
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        let height = NavBar.frame.height
        UIView.animateWithDuration(0.3) {
            self.NavBar.transform = CGAffineTransformMakeTranslation(0,-height)
            for view in self.viewArray {
                view.transform = CGAffineTransformMakeTranslation(0,100)
            }


        }
        
    }
    
    func setTitle(){
        var count = 0
        for dic in DataStruct.cities{
            if(count > 5){
                break
            }
            buttonArray[count].setTitle("\(dic.city), \(dic.state)", forState: .Normal)
            count = count + 1
        }
        for i in count ..< buttonArray.count {
            buttonArray[i].setTitle("< Empty >", forState: .Normal)
        }
    }
    func setUpUI(){
        for but in buttonArray {
            but.layer.cornerRadius = 10
            but.layer.masksToBounds = true
        }

        for del in self.deleteArray {
            del.alpha = 0
            del.hidden = true

        }
        let height = NavBar.frame.height
        NavBar.transform = CGAffineTransformMakeTranslation(0,-height)
        addButton.alpha = 0
        addButton.enabled = false
        setTitle()
    }
    
    @IBAction func backGroundButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(sender: UIButton) {
        let n = Int(sender.restorationIdentifier!)
        for del in deleteArray {
            del.enabled = false
        }
        
        UIView.animateWithDuration(0.2, animations: {
            let offset2 = n! - self.buttonPosition[n!]

            self.viewArray[n!].transform = CGAffineTransformMakeTranslation(-100, -CGFloat(offset2) * self.distance)
            self.viewArray[n!].alpha = 0
            
            }) { (Bool) in
                let offset = 6 - self.buttonPosition[n!]
                self.viewArray[n!].transform = CGAffineTransformMakeTranslation(0, -self.distance * CGFloat(offset))
                self.buttonArray[n!].setTitle("< Empty >", forState: .Normal)
                self.deleteArray[n!].hidden = true
                UIView.animateWithDuration(0.2, animations: {

//                    print(self.distance)
                    for i in (n!) ..<  self.viewArray.count {
                        self.viewArray[i].transform = CGAffineTransformTranslate(self.viewArray[i].transform, 0, self.distance)
                    }
                    self.viewArray[n!].alpha = 1

                }) { (Bool) in
                    if(DataStruct.cities.count > n!){
                        DataStruct.cities.removeAtIndex(n!)
                    }
                    
                    let button = self.buttonArray.removeAtIndex(n!)
                    self.buttonArray.append(button)
                    
                    let delete = self.deleteArray.removeAtIndex(n!)
                    self.deleteArray.append(delete)
                    
                    let pos = self.buttonPosition.removeAtIndex(n!)
                    self.buttonPosition.append(pos)
                    
                    let view = self.viewArray.removeAtIndex(n!)
                    self.viewArray.append(view)
                    
                    for i in 0 ..< self.deleteArray.count{
                        self.deleteArray[i].restorationIdentifier = "\(i)"
                        self.deleteArray[i].enabled = true
                    }
                }

        }
    }
    
    var userIsEditing = false
    @IBAction func editButtonPressed(sender: UIButton) {
        if(!userIsEditing){
            self.editButton.setTitle("Done", forState: UIControlState.Normal)
            addButton.alpha = 1
            addButton.enabled = true
            backGroundButton.enabled = false
            userIsEditing = true
            for button in buttonArray{
                button.enabled = false
            }

            var time = 0.0
            for i in 0 ..< self.deleteArray.count {
                let del = deleteArray[i]
                if(buttonArray[i].currentTitle! != "< Empty >"){
                    del.hidden = false
                    UIView.animateWithDuration(0.2, delay: time * 0.1 , options: UIViewAnimationOptions.CurveEaseInOut, animations:  {
                            del.alpha = 1
                        del.transform = CGAffineTransformRotate(del.transform, CGFloat(15 * M_PI))
                    }, completion: nil )
                    time = time + 1
                }
            }
        }
        else{
            userIsEditing = false
            addButton.alpha = 0
            addButton.enabled = false
            self.editButton.setTitle("Edit", forState: UIControlState.Normal)
            
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
    }

    @IBAction func addButtonPressed(sender: UIButton) {
        if userIsEditing{
            self.performSegueWithIdentifier("addSegue", sender: self)
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
