//
//  CityViewCell.swift
//  TabProject
//
//  Created by Santiago Ramirez on 29/04/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import UIKit

class CityViewCell: UICollectionViewCell {
    
    @IBOutlet var cityName: UILabel!
    @IBOutlet var weatherText: UILabel!
    @IBOutlet var icon: UIImageView!
    
    var cityId: String?
    
    override var isHighlighted: Bool {
      didSet {
        shrink(down: isHighlighted)
      }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderColor = UIColor(named: "CityItemBorder")?.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
    }
    
    public func set(city: CityData) {
        cityName.text = city.name
        weatherText.text = city.description
        icon.image = city.icon.image
        layer.backgroundColor = city.icon.color.cgColor
    }
    
    func shrink(down: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction], animations: {
            if down {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            } else {
                self.transform = .identity
            }
        })
    }
    
}
