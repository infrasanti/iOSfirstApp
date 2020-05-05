//
//  HorizontalCityViewCell.swift
//  TabProject
//
//  Created by Santiago Ramirez on 04/05/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit

class HorizontalCityViewCell: UITableViewCell {
    
    static let reuseIdentifier = "HorizontalCityViewCell"
    
    static func register(tableView: UITableView) {
        tableView.register(UINib(nibName: "HorizontalCityViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }

    @IBOutlet var temperature: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var icon: UIImageView!
    
    public func setCity(_ city: CityData) {
        cityName.text = city.name
        icon.image = city.icon.getIcon()
        weather.text = city.description
        temperature.text = "\(city.temp) ºC"
        layer.backgroundColor = city.icon.getColor().cgColor
    }
    
}
