//
//  CitiesPersistentStore.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/7/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import UIKit
import Foundation

let citiesKey = "CitiesKey"

class CitiesPersistentStore {
    private let defaults: UserDefaults
    
    var allCities: [String] {
        return defaults.object(forKey: citiesKey) as? [String] ?? []
    }
    
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    @discardableResult
    func add(city: String) -> [String] {
        var cities = allCities
        guard !cities.contains(city) else {
            Logger.info("adding a city that already exists")
            return cities
        }
        
        cities.append(city)
        return updateDefaults(with: cities)
    }
    
    @discardableResult
    func remove(city: String) -> [String] {
        var cities = allCities
        guard let index = cities.index(of: city) else {
            Logger.info("city does not exist \(city)")
            return cities
        }
        
        cities.remove(at: index)
        return updateDefaults(with: cities)
    }
    
    private func updateDefaults(with cities: [String]) -> [String] {
        defaults.set(cities, forKey: citiesKey)
        if !defaults.synchronize() {
            Logger.error("unable to write user defaults")
        }
        return cities
    }
}
