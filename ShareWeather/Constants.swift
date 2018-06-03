//
//  Constants.swift
//  ShareWeather
//
//  Created by Admin on 01.11.16.
//  Copyright © 2016 EvilMind. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


typealias DownloadComplete = () -> ()


//Location

private var _currentCoord: CLLocationCoordinate2D!
private var _currentCity: String!


var currentCoord: CLLocationCoordinate2D {
get {
    return _currentCoord
}
set {
    _currentCoord = newValue
}
}

var currentCity: String {
get {
    return _currentCity
}
set {
    _currentCity = newValue
}
}


//OpenWeatherMap

let API_KEY = "cb873633178db7c4b5d0b367a8ba803c"
let URL_BASE = "http://api.openweathermap.org/data/2.5/weather?"
let URL_STAFF = "&units=metric&appid="
