//
//  CityDetailsView.swift
//  TabProject
//
//  Created by Santiago Ramirez on 30/04/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit

class CityDetailsView: UIView {

    @IBOutlet var rootContainer: UIView!

    @IBOutlet var cloudyText: UILabel!
    @IBOutlet var windText: UILabel!
    @IBOutlet var humidityText: UILabel!
    @IBOutlet var tempText: UILabel!
    @IBOutlet var maxTempText: UILabel!
    @IBOutlet var minTempText: UILabel!
    @IBOutlet var nameText: UILabel!
    @IBOutlet var weatherText: UILabel!
    @IBOutlet var icon: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "CityDetailsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        rootContainer.frame = bounds
        addSubview(rootContainer)
    }
    
    public func setCity(_ city: CityData) {
        tempText.text = "\(city.temp)"
        maxTempText.text = "\(city.maxMinTemp.0)º"
        minTempText.text = "\(city.maxMinTemp.1)º"
        humidityText.text = "\(city.humidity)%"
        cloudyText.text = "\(city.cloudy)%"
        windText.text = "\(city.wind) m/s"

        nameText.text = city.name
        weatherText.text = city.description
        icon.image = city.icon.getIcon()
    }
}
