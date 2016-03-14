//
//  DataStruct.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/3/11.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DataStruct {
    static var needCheck = false
    
    static var jsonfile: JSON!
    static var hasError = false
    static var dayNum = 1
    static var errorInt : Int {
        get{
            DataStruct.hasError = true
            return 0
        }
    }
    static var errorDouble : Double {
        get{
            DataStruct.hasError = true
            return 0
        }
    }
    static var errorString : String {
        get{
            DataStruct.hasError = true
            return ""
        }
    }
    
    static var latitude = 0.00
    static var longitude = 0.00
    static var street = ""
    static var city = ""
    static var state = "Select"
    static var url = ""
    static var curr_temperature = 0
    static var fahrenheit = true
    static var curr_icon = ""
    static var curr_summary = ""
    static var curr_precipIntensity = 0.00
    static var curr_precipProbability = 0.00
    static var curr_windSpeed = 0.00
    static var curr_dewPoint = 0
    static var curr_humidity = 0.00
    static var curr_visibility = 0.00
    static var curr_sunriseTime = ""
    static var curr_sunsetTime = ""
    static var curr_LowTmp = 0
    static var curr_HighTmp = 0
    static var dic = Dictionary<Int, Array<String>>()
    
    static var dic7 = Dictionary<Int,Array<String>>()
}