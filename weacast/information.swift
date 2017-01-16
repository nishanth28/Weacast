//
//  information.swift
//  weacast
//
//  Created by Nishanth P on 12/31/16.
//  Copyright © 2016 Nishapp. All rights reserved.
//

import Foundation

typealias DownloadComplete = ()->()

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let CITY = "New+York"
let APP_ID = "&appid="
let API_KEY = "ed168af694450eed3b3b8e14735855a6"


let CURRENT_URL = "\(BASE_URL)q=\(CITY)\(APP_ID)\(API_KEY)"
let PREDICTION_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?q=New+York,US&appid=ed168af694450eed3b3b8e14735855a6"
//q=New+york,uk&appid=ed168af694450eed3b3b8e14735855a6
