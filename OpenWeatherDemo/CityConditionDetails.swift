//
//  CityConditionDetails.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/7/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

struct CityConditionDetails {
    let iconName: String
    let description: String
    let cityName: String
    let temperature: Int
    let minimumTemperature: Int?
    let maximumTemperature: Int?
    let humidity: Int?
    let windSpeed: Double?
    let windDirection: String?
    
    init?(condition: CurrentCondition?) {
        guard let condition = condition else {
            return nil
        }
        
        iconName = condition.iconName
        description = condition.description
        cityName = condition.city
        temperature = condition.temperature.current
        maximumTemperature = condition.temperature.max
        minimumTemperature = condition.temperature.min
        humidity = condition.humidity
        windSpeed = condition.wind.speed
        windDirection = condition.wind.cardinality
    }
}
