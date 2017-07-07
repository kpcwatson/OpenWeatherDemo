//
//  CityDetailsView.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/7/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import UIKit
import Foundation

class CityDetailsView: UIView {
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windDirection: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    var representedModel: CityConditionDetails? {
        didSet {
            guard let model = representedModel else {
                resetUiComponents()
                return
            }
            
            city.text = model.cityName
            icon.image = UIImage(named: model.iconName)
            desc.text = model.description
            currentTemperature.text = "\(model.temperature)°"
            
            if let max = model.maximumTemperature {
                maxTemperature.text = "\(max)°"
            }
            
            if let min = model.minimumTemperature {
                minTemperature.text = "\(min)°"
            }
            
            if let speed = model.windSpeed {
                windSpeed.text = "\(speed) mph"
            }
            
            if let direction = model.windDirection {
                windDirection.text = direction
            }
            
            if let humid = model.humidity {
                humidity.text = "\(humid)%"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        resetUiComponents()
    }
    
    private func resetUiComponents() {
        city.text = nil
        icon.image = nil
        desc.text = nil
        currentTemperature.text = nil
        maxTemperature.text = "-"
        minTemperature.text = "-"
        windSpeed.text = "-"
        windDirection.text = "-"
        humidity.text = "-"
    }
}
