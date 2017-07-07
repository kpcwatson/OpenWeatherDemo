//
//  CityCell.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import UIKit
import Foundation

class CityCell: UICollectionViewCell {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var currentTemperature: UILabel!
    
    var representedModel: BriefCityCondition? {
        didSet {
            guard let model = representedModel else {
                cityName.text = nil
                conditionImageView.image = nil
                currentTemperature.text = nil
                return
            }
            
            cityName.text = model.city
            currentTemperature.text = "\(model.temperature)°"
            conditionImageView.image = UIImage(named: model.iconName)
        }
    }
}
