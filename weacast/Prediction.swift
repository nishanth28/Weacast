//
//  Prediction.swift
//  weacast
//
//  Created by Nishanth P on 12/31/16.
//  Copyright © 2016 Nishapp. All rights reserved.
//

import UIKit
import Alamofire


extension Date{
    
    func dayOfTheWeek()->String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: self)

    }
    
}

class Prediction {
    
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp:String!
    
    var date : String {
        
        if _date == nil{
            _date = ""
        }
        return _date
    }
    
    var weatherType : String {
        
        if _weatherType == nil{
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp : String {
        
        if _highTemp == nil{
            _highTemp = ""
        }
        return _highTemp
    }

    var lowTemp : String {
        
        if _lowTemp == nil{
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    init (weatherDict: Dictionary<String,AnyObject>){
        
        if let temp = weatherDict["temp"] as? Dictionary<String,AnyObject>{
            
            if let min = temp["min"] as? Double {
                
                let ktoFstep1 = (min*(9/5)-459.67)
                let ktoF = Int(round(10*ktoFstep1/10))
                self._lowTemp = "\(ktoF)"+"°F"
                
            }
            
            if let max = temp["max"] as? Double {
                
                let ktoFstep1 = (max*(9/5)-459.67)
                let ktoF = Int(round(10*ktoFstep1/10))
                self._highTemp = "\(ktoF)"+"°F"
            }
            
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String,AnyObject>]
        {
            if let main = weather[0]["main"] as? String {
                
                self._weatherType = "\(main)"
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            
            let UnixConvDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = UnixConvDate.dayOfTheWeek()
            
            
        }
        
    }

    

    
}
