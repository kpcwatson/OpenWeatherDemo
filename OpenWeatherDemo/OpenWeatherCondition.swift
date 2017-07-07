//
//  OpenWeatherCondition.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

struct OpenWeatherCondition {
    let iconName: String
    let temperature: Double
    let city: String
    let minTemperature: Double?
    let maxTemperature: Double?
    let humidity: Int?
    let windSpeed: Double?
    let windDirection: Int?
}

extension OpenWeatherCondition: Mappable {
    init?(json: NSDictionary) {
        guard let weather: [NSDictionary] = json.value(for: "weather"),
            let iconName: String = weather.first?.value(for: "icon"),
            let temperature: Double = json.value(for: "main.temp"),
            let city: String = json.value(for: "name")
            else {
                return nil
        }
        
        self.iconName = iconName
        self.temperature = temperature
        self.city = city
//        self.city = json.value(for: "name")
        self.minTemperature = json.value(for: "main.temp_min")
        self.maxTemperature = json.value(for: "main.temp_max")
        self.humidity = json.value(for: "main.humidity")
        self.windSpeed = json.value(for: "wind.speed")
        self.windDirection = json.value(for: "wind.deg")
    }
}
