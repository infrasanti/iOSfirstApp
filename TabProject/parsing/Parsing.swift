//
//  Parsing.swift
//  TabProject
//
//  Created by Santiago Ramirez on 29/04/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import Foundation

class Weather: Codable {
    let main, description, icon: String
}

class Clouds: Codable {
    let all: Int
}

class Wind: Codable {
    let speed: Double
}

class MainData: Codable {
    let temp, temp_min, temp_max, humidity: Double
}

class City: Codable {
    let id: Int
    let name: String
    let main: MainData
    let clouds: Clouds
    let wind: Wind
    let weather: [Weather]
}

class Response: Codable {
    let list: [City]
}


