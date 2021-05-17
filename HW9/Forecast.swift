//
//  Forecast.swift
//  HW9
//
//  Created by Isaac Delgado on 12/1/19.
//  Copyright © 2019 Isaac Delgado. All rights reserved.
//

import Foundation
import UIKit

class Forecast {
    var forecastLabel: String
    var forecastIcon: UIImage
    var forecastSunriseTime: String
    var forecastSunsetTime: String
    
    init(label: String, icon: UIImage, sunriseTime: String, sunsetTime: String) {
        self.forecastLabel = label
        self.forecastIcon = icon
        self.forecastSunriseTime = sunriseTime
        self.forecastSunsetTime = sunsetTime
    }
}
