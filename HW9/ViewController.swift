//
//  ViewController.swift
//  HW9
//
//  Created by Isaac Delgado on 11/27/19.
//  Copyright © 2019 Isaac Delgado. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import CoreLocation
import GooglePlaces

class ViewController: UIViewController{
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var windspeedLbl: UILabel!
    @IBOutlet weak var visibilityLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var summaryLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var loadingScreen: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //this is the search box with autocomplete
    @IBOutlet weak var searchBox: UITextField!
    @IBAction func searching(_ sender: Any) {
        searchBox.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    //Table Content
    @IBOutlet weak var tableView: UITableView!
    var forecast: [Forecast] = [] //to hold all the weekday forcast objects
    
    //let parameters = ["street": "20015 Terra Canyon", "city": "San Antonio", "state": "Texas"]
    var parameters: [String: String] = [
        "street": "",
        "city": "San Antonio",
        "state": "Texas"
    ]
    var parametersCoordinates: [String: String] = [
           "latitude": "",
           "longitude": ""
       ]
    var json : JSON = []
    var mainCardInfo = (temperature: 0.0, summary: "", city: "", icon: "")
    var tempForDays = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var basicWeatherInfo: [String: Double] = [:]
    var weekDate = "", sunriseTime = "", sunsetTime = "" //these are for the for loop in getWeather function
    
    //Current location locationManager
    let locationManager = CLLocationManager()
    var locationUpdatedFlag = false
    
    override func viewDidLoad() {   //this runs when the application is started
        super.viewDidLoad()
        //getWeatherII()
        tableView.delegate = self
        tableView.dataSource = self
        let transfrom = CGAffineTransform.init(scaleX: 2.5, y: 2.5)
        activityIndicator.transform = transfrom
        
        //to make the Main Card View clickable
        mainCardView.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer.init(target: self, action: #selector(clickable))
        tapgesture.numberOfTapsRequired = 1
        mainCardView.addGestureRecognizer(tapgesture)
        
        //current location setup
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        //getWeatherlocaiton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let reciverVC = segue.destination as! ForecastDetailsController
        //reciverVC.testingLabel.text = self.parameters["city"]
        let tabController: UITabBarController = segue.destination as! UITabBarController
        let recieverVC = tabController.viewControllers![0] as! ForecastDetailsController
        let weeklyRecieverVC = tabController.viewControllers![1] as! WeeklyWeather
        recieverVC.json = self.json
        weeklyRecieverVC.json = self.json
        recieverVC.basicWeatherInfo = self.basicWeatherInfo
        recieverVC.summaryText = self.mainCardInfo.summary
    }
    
    @objc func clickable(){ //call to move to forecaset details
        print("Main Card View was clicked")
        self.performSegue(withIdentifier: "mySegueIdentifier", sender: nil)
        //let newVC = storyboard?.instantiateViewController(identifier: "forecastDetails") as? ForecastDetailsController
        //let newVC = storyboard?.instantiateViewController(identifier: "weatherdetails") as? ForecastDetailsController
        //let newVC = storyboard?.instantiateViewController(withIdentifier: "forecasttabbar") as! UITabBarController
        //navigationController?.pushViewController(newVC, animated: true)
        //newVC?.json = self.json
    }
    
    @IBAction func labelChange(_ sender: UIButton) {
        self.humidityLbl.text = String(self.basicWeatherInfo["humidity"]!*100) + " %"
        self.windspeedLbl.text = String(self.basicWeatherInfo["windspeed"]!) + " mph"
        self.visibilityLbl.text = String(self.basicWeatherInfo["visibility"]!) + " km"
        self.pressureLbl.text = String(self.basicWeatherInfo["pressure"]!) + " mb"
        self.temperatureLbl.text = String(mainCardInfo.temperature)
        self.summaryLbl.text = mainCardInfo.summary
        self.cityLbl.text = parameters["city"]
        //iconImg.image = UIImage(named: "weather-fog")
        switch mainCardInfo.icon {
        case "clear-day":
            iconImg.image = UIImage(named: "weather-sunny")
        case "clear-night":
            iconImg.image = UIImage(named: "weather-night")
        case "rain":
            iconImg.image = UIImage(named: "weather-rainy")
        case "snow":
            iconImg.image = UIImage(named: "weather-snowy")
        case "sleet":
            iconImg.image = UIImage(named: "weather-pouring")
        case "wind":
            iconImg.image = UIImage(named: "weather-windy")
        case "fog":
            iconImg.image = UIImage(named: "weather-fog")
        case "cloudy":
            iconImg.image = UIImage(named: "weather-cloudy")
        case "partly-cloudy-day":
            iconImg.image = UIImage(named: "weather-partly-cloudy")
        case "partly-cloudy-night":
            iconImg.image = UIImage(named: "weather-night-partly-cloudy")
        default:
            iconImg.image = UIImage(named: "weather-sunny")
        }
        self.tableView.reloadData() //reload data in table
    }
    
    func pushWeatherData(){
        self.humidityLbl.text = String(self.basicWeatherInfo["humidity"]!*100) + " %"
        self.windspeedLbl.text = String(self.basicWeatherInfo["windspeed"]!) + " mph"
        self.visibilityLbl.text = String(self.basicWeatherInfo["visibility"]!) + " km"
        self.pressureLbl.text = String(self.basicWeatherInfo["pressure"]!) + " mb"
        self.temperatureLbl.text = String(mainCardInfo.temperature)
        self.summaryLbl.text = mainCardInfo.summary
        self.cityLbl.text = parameters["city"]
        //iconImg.image = UIImage(named: "weather-fog")
        switch mainCardInfo.icon {
        case "clear-day":
            iconImg.image = UIImage(named: "weather-sunny")
        case "clear-night":
            iconImg.image = UIImage(named: "weather-night")
        case "rain":
            iconImg.image = UIImage(named: "weather-rainy")
        case "snow":
            iconImg.image = UIImage(named: "weather-snowy")
        case "sleet":
            iconImg.image = UIImage(named: "weather-pouring")
        case "wind":
            iconImg.image = UIImage(named: "weather-windy")
        case "fog":
            iconImg.image = UIImage(named: "weather-fog")
        case "cloudy":
            iconImg.image = UIImage(named: "weather-cloudy")
        case "partly-cloudy-day":
            iconImg.image = UIImage(named: "weather-partly-cloudy")
        case "partly-cloudy-night":
            iconImg.image = UIImage(named: "weather-night-partly-cloudy")
        default:
            iconImg.image = UIImage(named: "weather-sunny")
        }
        self.tableView.reloadData() //reload data in table
    }
    
    func weatherIcon(currentIcon: String) -> UIImage{
        var icon = UIImage()
        
        switch currentIcon {
        case "clear-day":
            icon = UIImage(named: "weather-sunny")!
        case "clear-night":
            icon = UIImage(named: "weather-night")!
        case "rain":
            icon = UIImage(named: "weather-rainy")!
        case "snow":
            icon = UIImage(named: "weather-snowy")!
        case "sleet":
            icon = UIImage(named: "weather-pouring")!
        case "wind":
            icon = UIImage(named: "weather-windy")!
        case "fog":
            icon = UIImage(named: "weather-fog")!
        case "cloudy":
            icon = UIImage(named: "weather-cloudy")!
        case "partly-cloudy-day":
            icon = UIImage(named: "weather-partly-cloudy")!
        case "partly-cloudy-night":
            icon = UIImage(named: "weather-night-partly-cloudy")!
        default:
            icon = UIImage(named: "weather-sunny")!
        }
        return icon
    }
    
    func getWeatherII(){
        AF.request("https://responsiveforecasthw.appspot.com/forecast", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseJSON { result in
            self.json = JSON(result.value!)
            self.basicWeatherInfo["humidity"] = self.json["currently"]["humidity"].doubleValue
            self.basicWeatherInfo["windspeed"] = self.json["currently"]["windSpeed"].doubleValue
            self.basicWeatherInfo["visibility"] = self.json["currently"]["visibility"].doubleValue
            self.basicWeatherInfo["pressure"] = self.json["currently"]["pressure"].doubleValue
            self.basicWeatherInfo["summary"] = self.json["currently"]["summary"].doubleValue
            self.mainCardInfo.temperature = self.json["currently"]["temperature"].doubleValue
            self.mainCardInfo.summary = self.json["currently"]["summary"].stringValue
            self.mainCardInfo.icon = self.json["currently"]["icon"].stringValue
                
            var date = Date()
            let format = DateFormatter()
            format.dateFormat = "MM/dd/yyyy"
            
            var sunriseDate = Date()
            let formatSunrise = DateFormatter()
            formatSunrise.dateFormat = "HH:mm"
            
            var sunsetDate = Date()
            let formatSunset = DateFormatter()
            formatSunset.dateFormat = "HH:mm"
                
            var jsonDate = 0.0
            var iconString = ""
            var sunriseTime = 0.0
            var sunsetTime = 0.0
            var iconTemp = UIImage()
                
                
            for index in 0...7{
                jsonDate = self.json["daily"]["data"][index]["time"].doubleValue
                sunriseTime = self.json["daily"]["data"][index]["sunriseTime"].doubleValue
                sunsetTime = self.json["daily"]["data"][index]["sunsetTime"].doubleValue
                iconString = self.json["daily"]["data"][index]["icon"].stringValue
                date = Date(timeIntervalSince1970: jsonDate)
                self.weekDate = format.string(from: date)
                
                sunriseDate = Date(timeIntervalSince1970: sunriseTime)
                self.sunriseTime = formatSunrise.string(from: sunriseDate)
                
                sunsetDate = Date(timeIntervalSince1970: sunsetTime)
                self.sunsetTime = formatSunset.string(from: sunsetDate)
                
                iconTemp = self.weatherIcon(currentIcon: iconString)
                
                self.forecast.append(Forecast(label: self.weekDate, icon: iconTemp, sunriseTime: self.sunriseTime, sunsetTime: self.sunsetTime))
            }
        }
    }
    
    func getWeatherlocaiton(){
         AF.request("https://responsiveforecasthw.appspot.com/forecast_swiftLocation", method: .post, parameters: parametersCoordinates, encoder: JSONParameterEncoder.default).responseJSON {result in
            self.json = JSON(result.value!)
            self.basicWeatherInfo["humidity"] = self.json["currently"]["humidity"].doubleValue
            self.basicWeatherInfo["windspeed"] = self.json["currently"]["windSpeed"].doubleValue
            self.basicWeatherInfo["visibility"] = self.json["currently"]["visibility"].doubleValue
            self.basicWeatherInfo["pressure"] = self.json["currently"]["pressure"].doubleValue
            self.basicWeatherInfo["summary"] = self.json["currently"]["summary"].doubleValue
            self.mainCardInfo.temperature = self.json["currently"]["temperature"].doubleValue
            self.mainCardInfo.summary = self.json["currently"]["summary"].stringValue
            self.mainCardInfo.icon = self.json["currently"]["icon"].stringValue
                
            var date = Date()
            let format = DateFormatter()
            format.dateFormat = "MM/dd/yyyy"
            
            var sunriseDate = Date()
            let formatSunrise = DateFormatter()
            formatSunrise.dateFormat = "HH:mm"
            
            var sunsetDate = Date()
            let formatSunset = DateFormatter()
            formatSunset.dateFormat = "HH:mm"
                
            var jsonDate = 0.0
            var iconString = ""
            var sunriseTime = 0.0
            var sunsetTime = 0.0
            var iconTemp = UIImage()
                
                
            for index in 0...7{
                jsonDate = self.json["daily"]["data"][index]["time"].doubleValue
                sunriseTime = self.json["daily"]["data"][index]["sunriseTime"].doubleValue
                sunsetTime = self.json["daily"]["data"][index]["sunsetTime"].doubleValue
                iconString = self.json["daily"]["data"][index]["icon"].stringValue
                date = Date(timeIntervalSince1970: jsonDate)
                self.weekDate = format.string(from: date)
                
                sunriseDate = Date(timeIntervalSince1970: sunriseTime)
                self.sunriseTime = formatSunrise.string(from: sunriseDate)
                
                sunsetDate = Date(timeIntervalSince1970: sunsetTime)
                self.sunsetTime = formatSunset.string(from: sunsetDate)
                
                iconTemp = self.weatherIcon(currentIcon: iconString)
                
                self.forecast.append(Forecast(label: self.weekDate, icon: iconTemp, sunriseTime: self.sunriseTime, sunsetTime: self.sunsetTime))
            }
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecastTemp = forecast[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell") as! ForecastCell
        cell.setForecast(forecast: forecastTemp)
        
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        guard let location: CLLocation = manager.location else { return }
        parametersCoordinates["latitude"] = String(locValue.latitude)
        parametersCoordinates["longitude"] = String(locValue.longitude)
        
        print(parametersCoordinates)
        
        if !locationUpdatedFlag{
            fetchCityAndCountry(from: location) { city, country, error in
                guard let city = city, let country = country, error == nil else { return }
                print(city + ", " + country)
                self.parameters["city"] = city
            }
            getWeatherlocaiton()
            self.locationUpdatedFlag = true
        }
        //getWeatherlocaiton()
        //print(self.basicWeatherInfo["humidity"] == nil)
        if (self.basicWeatherInfo["humidity"] != nil){ //wait till the data is stored to push to screen
            pushWeatherData()
            print("im here")
            activityIndicator.stopAnimating()
            loadingScreen.removeFromSuperview()
        }else{
            locationManager.startUpdatingLocation()
        }
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
          // Get the place name from 'GMSAutocompleteViewController'
          // Then display the name in textField
        searchBox.text = place.name// Dismiss the GMSAutocompleteViewController when something is selected
        print(place.coordinate.latitude)
        dismiss(animated: true, completion: nil)
        self.parameters["city"] = place.name
        parametersCoordinates["latitude"] = String(place.coordinate.latitude)
        parametersCoordinates["longitude"] = String(place.coordinate.longitude)
        print(parametersCoordinates)
        getWeatherlocaiton()
        if (self.basicWeatherInfo["humidity"] != nil){ //wait till the data is stored to push to screen
            pushWeatherData()
        }
        
    }
        
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
          // Handle the error
        print("Error: ", error.localizedDescription)
    }
        
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
          // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
}


