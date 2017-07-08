//
//  CurrentCondition.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

struct Temperatures {
    let current: Int
    let min: Int?
    let max: Int?
}

extension Temperatures: Equatable {
    static func ==(lhs: Temperatures, rhs: Temperatures) -> Bool {
        return lhs.current == rhs.current
            && lhs.min == rhs.min
            && lhs.max == rhs.max
    }
}

struct Wind {
    let speed: Double?
    let direction: Int?
    
    var cardinality: String? {
        var cardinality: String?
        
        guard let direction = direction else {
            return cardinality
        }
        
        switch direction {
        case 0..<23, 338..<360:
            cardinality = "N"
        case 23..<68:
            cardinality = "NE"
        case 68..<113:
            cardinality = "E"
        case 113..<158:
            cardinality = "SE"
        case 158..<203:
            cardinality = "S"
        case 203..<248:
            cardinality = "SW"
        case 248..<293:
            cardinality = "W"
        case 293..<338:
            cardinality = "NW"
        default:
            fatalError("received invalid wind direction \(direction)")
        }
        
        return cardinality
    }
}

extension Wind: Equatable {
    static func ==(lhs: Wind, rhs: Wind) -> Bool {
        return lhs.speed == rhs.speed
            && lhs.direction == rhs.direction
    }
}

struct CurrentCondition {
    let iconName: String
    let description: String
    let temperature: Temperatures
    let city: String
    let humidity: Int?
    let wind: Wind
}

extension CurrentCondition: Equatable {
    static func ==(lhs: CurrentCondition, rhs: CurrentCondition) -> Bool {
        return lhs.iconName == rhs.iconName
            && lhs.description == rhs.description
            && lhs.temperature == rhs.temperature
            && lhs.city == rhs.city
            && lhs.humidity == rhs.humidity
            && lhs.wind == rhs.wind
    }
}
