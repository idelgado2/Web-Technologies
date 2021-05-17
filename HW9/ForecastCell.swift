//
//  ForecastCell.swift
//  HW9
//
//  Created by Isaac Delgado on 12/1/19.
//  Copyright © 2019 Isaac Delgado. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {
    @IBOutlet weak var forecastLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var sunriseTime: UILabel!
    @IBOutlet weak var sunsetTime: UILabel!
    @IBOutlet weak var sunriseIcon: UIImageView!
    @IBOutlet weak var sunsetIcon: UIImageView!
    
    func setForecast(forecast: Forecast){
        forecastLabel.text = forecast.forecastLabel
        iconImage.image = forecast.forecastIcon
        sunriseTime.text = forecast.forecastSunriseTime
        sunsetTime.text = forecast.forecastSunsetTime
        sunriseIcon.image = UIImage(named: "weather-sunset-up")!
        sunsetIcon.image = UIImage(named: "weather-sunset-down")!
    }
}
