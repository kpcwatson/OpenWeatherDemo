//
//  BriefCityCondition.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

struct BriefCityCondition {
    let city: String
    let iconName: String
    let temperature: Int
    
    init?(condition: CurrentCondition?) {
        guard let condition = condition else {
            return nil
        }
        
        city = condition.city
        iconName = condition.iconName
        temperature = Int(condition.temperature.current)
    }
}
