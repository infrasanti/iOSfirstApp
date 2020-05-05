//
//  WeatherApi.swift
//  TabProject
//
//  Created by Santiago Ramirez on 05/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import Foundation

public class WeatherApi {
    private static let url = URL(string: "https://api.openweathermap.org/data/2.5/group?id=3936456,3104324,1854747,2988507,98182,2147714&units=metric&appid=2dd173a48af7963a23cc05fe98ae31e2")!
    
    func request(_ callback: @escaping (Response?, String?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: WeatherApi.url, completionHandler: { data, urlResponse, error in

            if let e = error {
                callback(nil, e.localizedDescription)
            }
            
            if let data = data {
                
                do {
                    let weatherData = try JSONDecoder().decode(Response.self, from: data)
                    callback(weatherData, nil)
                } catch {
                    callback(nil, "Parsing error :(")
                }
            }
            
        })
        task.resume()
    }
    
}
