//
//  Next24HoursTableViewCell.swift
//  CS571_hw9
//
//  Created by Huiyuan Ren on 15/11/24.
//  Copyright © 2015年 Huiyuan Ren. All rights reserved.
//

import UIKit

class Next24HoursTableViewCell: UITableViewCell {

    var data : Int = 0{
        didSet{
            updateUI()
        }
    }
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateUI(){

        
        
        time.text = DataStruct.jsonfile["hourly"]["data"][data]["time"] != nil ? DataStruct.jsonfile["hourly"]["data"][data]["time"].string! : DataStruct.errorString
        icon.image = UIImage(named: DataStruct.jsonfile["hourly"]["data"][data]["icon"] != nil ? DataStruct.jsonfile["hourly"]["data"][data]["icon"].string! : DataStruct.errorString)
        temp.text = "\(DataStruct.jsonfile["hourly"]["data"][data]["temperature"] != nil ? DataStruct.jsonfile["hourly"]["data"][data]["temperature"].int! : DataStruct.errorInt)"
        
        
    }

}
