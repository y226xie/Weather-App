//
//  ViewController.swift
//  WeatherApp
//
//  Created by Yuan Xie on 2018-04-25.
//  Copyright © 2018 Yuan Xie. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController , CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e802d3340c98acbaa52b0189b010eb5f"
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        
        locationManager.delegate = self //we setting up the WeatherViewController as the delegate of the location manager, so the location manager knows who to report to once it found the data we are looking for
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() //Asynhronous Method, it works in the background to try and grab the GPS location Coordinates. If it works in the foreground, i.e.  if it was on what we called the main threat, it would freeze up the entire app. We won't be able to interact with it until it's done looking for the GPS location
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url:String , parameters: [String : String] ){
        
        Alamofire.request(url, method:.get , parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
                
            }
            else{
                
                print("Error")// repsonse.result.error
                self.cityLabel.text = " Connection Issues"
            } // The part is between response in is what should get trigger once the background process has completed and we get data back from the server. It's asynchronous
        }
        
    }
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    
    func updateWeatherData(json: JSON){
        
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
        }
        else{
            cityLabel.text = "Sorry! Weather Unavailable"
        }
        
        
        
    }
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData(){
        
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    
    }
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1] // to get the last value in the array
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
        } // once, we recieve a valid location, we should stop looking for more, because it really takes battery. The horizontalAccuracy > 0 represents a valid location.
        
        let longitude = String(location.coordinate.longitude)
        let latitude = String(location.coordinate.latitude)
        
        let params : [ String: String ] = [ "lon": longitude, "lat" : latitude, "appid": APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }//Note: The CLLocation object contains altitude and longtitude of the location, it is an array, and it will keep update and the data is getting more accurate, so that the last element in the array should be the most accurate one.
    
    
    
    //Write the didFailWithError method here:
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Sorry, Location Unavailable!"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    
    func userEnteredANewCityName(city: String) {
        
        let params : [ String : String ] = [ "q" : city, "appid": APP_ID ]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    

    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName"{
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        }
    }
    
    
    
    
    
}


