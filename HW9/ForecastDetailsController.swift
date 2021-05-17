//
//  ForecastDetailsController.swift
//  HW9
//
//  Created by Isaac Delgado on 12/1/19.
//  Copyright © 2019 Isaac Delgado. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForecastDetailsController: UIViewController {

    var json : JSON = []
    var basicWeatherInfo: [String: Double] = [:]
    
    @IBOutlet weak var windspeedlbl: UILabel!
    @IBOutlet weak var pressurelbl: UILabel!
    @IBOutlet weak var precipitationlbl: UILabel!
    @IBOutlet weak var temperaturelbl: UILabel!
    @IBOutlet weak var humiditylbl: UILabel!
    @IBOutlet weak var visibilitylbl: UILabel!
    @IBOutlet weak var cloudcoverlbl: UILabel!
    @IBOutlet weak var ozonelbl: UILabel!
    
    @IBOutlet weak var summaryIcon: UIImageView!
    @IBOutlet weak var summary: UILabel!
    
    var summaryText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.humiditylbl.text = String(self.basicWeatherInfo["humidity"]!*100) + " %"
        self.windspeedlbl.text = String(self.basicWeatherInfo["windspeed"]!) + " mph"
        self.visibilitylbl.text = String(self.basicWeatherInfo["visibility"]!) + " km"
        self.pressurelbl.text = String(self.basicWeatherInfo["pressure"]!) + " mb"
        self.precipitationlbl.text = String(self.json["currently"]["precipIntensity"].doubleValue)
        self.temperaturelbl.text = String(self.json["currently"]["temperature"].doubleValue)
        self.cloudcoverlbl.text = String(self.json["currently"]["cloudCover"].doubleValue)
        self.ozonelbl.text = String(self.json["currently"]["ozone"].doubleValue)
        self.summary.text = self.summaryText
        self.summaryIcon.image = UIImage(named: getIcon(weather: self.json["currently"]["icon"].stringValue))
    }
    
    func getIcon(weather: String) -> String{
        var file = ""
        switch weather {
        case "clear-day":
            file = "weather-sunny"
        case "clear-night":
            file = "weather-night"
        case "rain":
            file = "weather-rainy"
        case "snow":
            file = "weather-snowy"
        case "sleet":
            file = "weather-pouring"
        case "wind":
            file = "weather-windy"
        case "fog":
            file = "weather-fog"
        case "cloudy":
            file = "weather-cloudy"
        case "partly-cloudy-day":
            file = "weather-partly-cloudy"
        case "partly-cloudy-night":
            file = "weather-night-partly-cloudy"
        default:
            file = "weather-sunny"
        }
        return file
    }

}
