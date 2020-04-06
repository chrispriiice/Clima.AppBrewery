//
//  WeatherManager.swift
//  Clima
//
//  Created by Chris Price on 3/20/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=imperial&appid=a26eee69777c944576e3bf3243f7cb13"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        // 2) Create URLSession
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        
        // 1) Create URL
        if let url = URL(string: urlString) {
            
            // 2) Create URLSession
            let session = URLSession(configuration: .default)
            
            // 3) Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            
            // 4) Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodedData.main.temp
            let name = decodedData.name
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(weather.temperatureString)
            
        } catch {
            print(error)
        }
    }
    

    
}
