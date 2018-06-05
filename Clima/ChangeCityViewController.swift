//
//  ChangeCityViewController.swift
//  Clima
//
//  Created by David Huang on 03/27/18.
//  Copyright © 2018 David Huang. All rights reserved.
//

import UIKit


protocol ChangeCityDelegate{
    func userEnteredANewCityName(city : String)
}

class ChangeCityViewController: UIViewController {

    var delegate : ChangeCityDelegate? //Optional, can be nil or someone else can be the delegate
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        //1 Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: cityName) //Optional chaining, is the delegate nil? if not than execute function
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
