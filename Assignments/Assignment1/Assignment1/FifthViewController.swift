//
//  FifthViewController.swift
//  Assignment1
//
//  Created by Ryan Mitchell on 9/10/20.
//  Copyright © 2020 Ryan Mitchell. All rights reserved.
//

import UIKit
import Foundation

class FifthViewController: UIViewController {
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var inputTextField: UITextField!
    
    let apiKey = "bdd06717f02001e28d865c29f4c95303"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func getWeatherButtonTapped(_ sender: Any) {
        self.outputLabel.isHidden = true
        loadingSpinner.startAnimating()
        let city: String = inputTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=imperial")
         
        pullJSONData(url: url)
         
    }
    struct Weather: Codable {
        var temp: Double?
        var humidity: Double?
    }
     
    struct WeatherMain: Codable{
        let main: Weather
    }
     
    func decodeJSONData(JSONData: Data){
        do{
            let weatherData = try? JSONDecoder().decode(WeatherMain.self, from: JSONData)
            if let weatherData = weatherData{
                let weather = weatherData.main
                DispatchQueue.main.async {

                    self.outputLabel.text = "City: \(self.inputTextField.text!)\nTemperature: \(weather.temp!)°F\nHumidity: \(weather.humidity!)%"
                    self.inputTextField.text = ""
                    self.loadingSpinner.stopAnimating()
                    self.outputLabel.isHidden = false
                }
            }
        }
    }
    
    func pullJSONData(url: URL?){
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                self.outputLabel.text = "An unknown error has occured, please try again or try searching for a different city."
                self.loadingSpinner.stopAnimating()
                self.outputLabel.isHidden = false
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error : HTTP Response Code Error")
                DispatchQueue.main.async {
                    self.outputLabel.text = "An unknown error has occured, please try again or try searching for a different city."
                    self.loadingSpinner.stopAnimating()
                    self.outputLabel.isHidden = false
                    
                }
                return
            }
            
            guard let data = data else {
                print("Error : No Response")
                DispatchQueue.main.async {
                    self.outputLabel.text = "An unknown error has occured, please try again or try searching for a different city."
                    self.loadingSpinner.stopAnimating()
                    self.outputLabel.isHidden = false
                }
                return
            }
            
            self.decodeJSONData(JSONData: data)
            
        }
        task.resume()
    }
}
