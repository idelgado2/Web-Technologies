//
//  WeeklyWeather.swift
//  HW9
//
//  Created by Isaac Delgado on 12/3/19.
//  Copyright © 2019 Isaac Delgado. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Charts

class WeeklyWeather: UIViewController {

    var json : JSON = []
    
    @IBOutlet weak var summaryIcon: UIImageView!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.summary.text = self.json["daily"]["summary"].stringValue
        self.summaryIcon.image = UIImage(named: getIcon(weather: self.json["daily"]["icon"].stringValue))
        //setChartValues()
        setMaxMinTemps()
    }
    
    func setChartValues(_ count : Int = 20){
        let values = (0..<count).map{
            (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(UInt32(count)) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
        let data = LineChartData(dataSet: set1)
        
        self.lineChartView.data = data
    }
    
    func setMaxMinTemps(){
        var tempSets = [IChartDataSet]()
        let highTemps = (0...7).map{
            (i) -> ChartDataEntry in
            let maxTemp = self.json["daily"]["data"][i]["temperatureHigh"].doubleValue
            return ChartDataEntry(x: Double(i), y: maxTemp)
        }
        let lowTemps = (0...7).map{
            (i) -> ChartDataEntry in
            let maxTemp = self.json["daily"]["data"][i]["temperatureLow"].doubleValue
            return ChartDataEntry(x: Double(i), y: maxTemp)
        }
        let set2 = LineChartDataSet(entries: highTemps, label: "Maximum Temperature (F)")
        let set1 = LineChartDataSet(entries: lowTemps, label: "Minimum Temperature (F)")
        set2.setCircleColor(UIColor.orange)
        set2.setColor(UIColor.orange)
        set1.setCircleColor(UIColor.white)
        set1.setColor(UIColor.white)
        tempSets.append(set1)
        tempSets.append(set2)
        let data = LineChartData(dataSets: tempSets)
        self.lineChartView.data = data
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
