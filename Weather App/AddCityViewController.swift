//
//  AddCityViewController.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/4/20.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {

    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backGroundView.layer.cornerRadius = 10
        let paddingView = UIView.init(frame: CGRectMake(0, 0, 8, 30))
        cityTextField.leftView = paddingView
        cityTextField.leftViewMode = UITextFieldViewMode.Always

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
