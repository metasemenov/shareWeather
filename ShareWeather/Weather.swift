//
//  Weather.swift
//  ShareWeather
//
//  Created by Admin on 07.11.16.
//  Copyright © 2016 EvilMind. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation


class Weather {
    
    private var _currentTemp: String!
    private var _currentIconName: String!
    
    
  
    
    var currentTemp: String {
        if _currentTemp == nil {
            return ""
        }
        return _currentTemp
    }
    
    var currentIconName: String {
        if _currentIconName == nil {
            return ""
        }
        return _currentIconName
    }
    
   

    
    func loadWeatherData(lat: CLLocationDegrees, lon: CLLocationDegrees ,completed: @escaping DownloadComplete) {
        let url = "\(URL_BASE)lat=\(lat)&lon=\(lon)\(URL_STAFF)\(API_KEY)"
      

        Alamofire.request(url).responseJSON { response in
                let result = response.result
                
                if let dict = result.value as? Dictionary<String, AnyObject> {

                    if let tempDict = dict["main"] as? Dictionary<String, AnyObject> {
                        if let temp = tempDict["temp"] as? Double {
                            self._currentTemp = "\(lround(temp))"
                        }
                    }

                    if let idict = dict["weather"] as? [Dictionary<String, AnyObject>] {
                        if let iconDict = idict[0] as? Dictionary<String, AnyObject> {
                            if let icon = iconDict["icon"] as? String {
                                self._currentIconName = icon
                            }
                        }
                    }
            
                }
                completed()
        }
        
        
    }
    

}


