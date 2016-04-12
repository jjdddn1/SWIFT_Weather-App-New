//
//  Location.swift
//  Weather App
//
//  Created by Huiyuan Ren on 16/4/12.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import Foundation

class Location: NSObject, NSCoding {
    internal var city = ""
    internal var state = ""
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("cities")
    
    
    
    init?(city: String, state: String){
        self.city = city
        self.state = state
        super.init()
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let city = aDecoder.decodeObjectForKey("cityName") as! String
        let state = aDecoder.decodeObjectForKey("stateName") as! String
        self.init(city: city, state: state)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(city, forKey: "cityName")
        aCoder.encodeObject(state, forKey: "stateName")
    }
    func getCity() -> String{
        return self.city
    }
    func getState() -> String{
        return self.state
    }
}
