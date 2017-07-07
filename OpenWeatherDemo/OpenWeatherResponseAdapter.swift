//
//  OpenWeatherResponseAdapter.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

class OpenWeatherResponseAdapter {
    
    func toCurrentCondition(_ owCondition: OpenWeatherCondition, in city: String? = nil) -> CurrentCondition {
        return CurrentCondition(iconName: owCondition.iconName,
                                temperature: temperatures(from: owCondition),
                                city: city ?? owCondition.city,
                                humidity: owCondition.humidity,
                                wind: wind(from: owCondition))
    }
    
    private func temperatures(from condition: OpenWeatherCondition) -> Temperatures {
        return Temperatures(current: condition.temperature,
                            min: condition.minTemperature,
                            max: condition.maxTemperature)
    }
    
    private func wind(from condition: OpenWeatherCondition) -> Wind {
        return Wind(speed: condition.windSpeed,
                    direction: condition.windDirection)
    }
}
