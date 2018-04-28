//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Yuan Xie on 2018-04-25.
//  Copyright © 2018 Yuan Xie. All rights reserved.
//

import UIKit


//Write the protocol declaration here:
protocol ChangeCityDelegate {
    
    func userEnteredANewCityName( city : String )
    
}



class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate?
  
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        //1 Get the city name the user entered in the text field
         let cityName = changeCityTextField.text!
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        
        delegate?.userEnteredANewCityName(city: cityName) // Optional chaining, it's checking to see if this optional has a value or not.If the delegate value has a value, then this method will get execuation, if is not, this method wll get ignore
        
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
