//
//  Mappable.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

protocol Mappable {
    init?(json: NSDictionary)
}

extension Mappable {
    static func from(_ json: NSDictionary) -> Self? {
        return Self(json: json)
    }
}
