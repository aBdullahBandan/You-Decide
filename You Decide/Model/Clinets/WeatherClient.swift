//
//  WeatherClient.swift
//  You Decide
//
//  Created by Abdullah Bandan on 17/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import Foundation
import SwiftSky
import Pods_You_Decide

class WeatherClient{

    class func Auth(){
        SwiftSky.secret = "51ff9fc2b6c1a933f8907c0bc416adf7"
        SwiftSky.hourAmount = .fortyEight
        SwiftSky.language = .english
        SwiftSky.locale = .autoupdatingCurrent
        SwiftSky.units.temperature = .celsius
        SwiftSky.units.distance = .mile
        SwiftSky.units.speed = .kilometerPerHour
        SwiftSky.units.pressure = .millibar
        SwiftSky.units.precipitation = .millimeter
        SwiftSky.units.accumulation = .centimeter
    }
    class func getWhether(lat: Double,lon: Double, completion: @escaping (Forecast?, Error?) -> Void) {
          Auth()
          SwiftSky.get([.current, .minutes, .hours, .days, .alerts], at: Location(latitude: lat, longitude: lon)
        ) { result in
            switch result {
            case .success(let forecast):
                completion(forecast,nil)
                break
                // do something with forecast
            case .failure(let error):
                completion(nil,error)
                break
                }
            }
        }


}

