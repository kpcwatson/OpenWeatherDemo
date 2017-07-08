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

class CitiesPersistentStore: Persistable {
    typealias Entity = String
    
    private let defaults: UserDefaults
    
    var allObjects: [String] {
        return defaults.object(forKey: citiesKey) as? [String] ?? []
    }
    
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    func add(_ city: Entity) {
        var cities = allObjects
        guard !cities.contains(city) else {
            Logger.info("adding a city that already exists")
            return
        }
        
        cities.append(city)
        updateDefaults(with: cities)
    }
    
    func remove(_ city: String) {
        var cities = allObjects
        guard let index = cities.index(of: city) else {
            Logger.info("city does not exist \(city)")
            return
        }
        
        cities.remove(at: index)
        updateDefaults(with: cities)
    }
    
    private func updateDefaults(with cities: [String]) {
        defaults.set(cities, forKey: citiesKey)
        if !defaults.synchronize() {
            Logger.error("unable to write user defaults")
        }
    }
}
