//
//  DashModel.swift
//  TabProject
//
//  Created by Santiago Ramirez on 29/04/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import Foundation
import UIKit

class CityData {
    public let id: Int
    public let name: String
    public let icon: WeatherIcon
    public let description: String
    public let temp: Int
    public let maxMinTemp: (Int, Int)
    public let humidity: Int
    public let wind: Double
    public let cloudy: Int
    
    init(city: City) {
        self.id = city.id
        self.name = city.name
        self.temp = Int(city.main.temp)
        self.maxMinTemp = (Int(city.main.temp_max), Int(city.main.temp_min))
        self.humidity = Int(city.main.humidity)
        self.wind = city.wind.speed
        self.cloudy = city.clouds.all
        if !city.weather.isEmpty {
            let weather = city.weather[0]
            self.description = weather.description
            if let icon = WeatherIcon(rawValue: weather.icon) {
                self.icon = icon
            } else {
                self.icon = .unknown
            }
        } else {
            self.description = "???"
            self.icon = .unknown
        }
    }
}

enum WeatherIcon: String {
    case sunny = "01d"
    case fewClouds = "02d"
    case clouds = "03d"
    case manyClouds = "04d"
    case showerRain = "09d"
    case rain = "10d"
    case storm = "11d"
    case snow = "13d"
    case mist = "50d"
    case sunnyNight = "01n"
    case fewCloudsNight = "02n"
    case cloudsNight = "03n"
    case manyCloudsNight = "04n"
    case showerRainNight = "09n"
    case rainNight = "10n"
    case stormNight = "11n"
    case snowNight = "13n"
    case mistNight = "50n"
    case unknown = ""
    
    public var image: UIImage {
        return UIImage(systemName: iconName)!
    }
    
    public var color: UIColor {
        return UIColor(named: colorName)!
    }
    
    private var iconName: String {
        switch self {
               case .sunny:
                   return "sun.max"
               case .sunnyNight:
                   return "moon"
               case .fewClouds:
                   return "cloud.sun"
               case .fewCloudsNight:
                   return "cloud.moon"
               case .clouds, .cloudsNight:
                   return "cloud"
               case .manyClouds, .manyCloudsNight:
                   return "smoke"
               case .showerRain, .showerRainNight:
                   return "cloud.drizzle"
               case .rain, .rainNight:
                   return "cloud.heavyrain"
               case .storm, .stormNight:
                   return "cloud.bolt.rain"
               case .snow, .snowNight:
                   return "snow"
               case .mist, .mistNight:
                   return "sun.haze"
               case .unknown:
                   return "questionmark.circle"
               }
    }
    
    private var colorName: String {
        switch self {
        case .sunny:
            return "sun"
        case .fewClouds:
            return "fewClouds"
        case .clouds, .showerRain:
            return "clouds"
        case .manyClouds, .rain, .storm, .snow, .mist:
            return "manyClouds"
        default:
            return "night"
        }
    }
    
}
