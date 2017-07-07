//
//  NSDictionary+ValueInference.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

/// convenience extension to use type-inference instead of needing to cast
extension NSDictionary {
    func value<T>(for keyPath: String) -> T? {
        return self.value(forKeyPath: keyPath) as? T
    }
}
