//
//  ViewController.swift
//  Clima
//
//  Created by David Huang on 03/27/18.
//  Copyright © 2018 David Huang. All rights reserved.
//

import UIKit
import CoreLocation //Location Services Library
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "b9bec5f24b66e39bab23244569c8cf29"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self //Set the Location Manager also as the delegate, report to self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters //Set Location Accuracy
        locationManager.requestWhenInUseAuthorization() //Request to use location from user
        locationManager.startUpdatingLocation() //Start looking for GPS Coordinates
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getWeatherData(url : String, parameters: [String : String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{ //URL, HTTP Request, Parameters
            response in //Retrieve Data Asynchronously (in the background)
            if response.result.isSuccess {
                print("Success! Weather data is retrieved")
                
                let weatherJSON : JSON = JSON(response.result.value!)//Force unwrapping here because we checked for response success
                self.updateWeatherData(json: weatherJSON) //Call self here because response in is a closure
            }
            else{
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    func updateWeatherData(json : JSON){
        
        if let tempResult = json["main"]["temp"].double{//Optional binding, check if JSON Request has valid data, don't have to unwrap
        
            weatherDataModel.temperature = Int(tempResult - 273.15)
        
            weatherDataModel.city = json["name"].stringValue
        
            weatherDataModel.condition = json["weather"]["id"].intValue
        
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWIthWeatherData() //Now update after passing JSON data
            
        
        }
        else{
            cityLabel.text = "Weather unavailable." //If JSON returns error code
        }
        
       
        
        
    }
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    func updateUIWIthWeatherData(){
        
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = String(weatherDataModel.temperature) + "°c"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
    }
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{ //Location is valid
            locationManager.stopUpdatingLocation()
            print("longitutde = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params: [String : String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
            
        }
        
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailable."
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    func userEnteredANewCityName(city: String) {
        getWeatherData(url: WEATHER_URL, parameters: ["q" : city, "appid" : APP_ID ]) //q is city name according to OpenWeatherAPI
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let destinationViewController = segue.destination as! ChangeCityViewController
            
            destinationViewController.delegate = self
            
        }
    }
    
    
    
}


