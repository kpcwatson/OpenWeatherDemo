//
//  OpenWeatherApiClient.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

struct OpenWeatherEndpoint {
    static let current = "current"
}

class OpenWeatherApiClient: BaseApiClient {
    
    func currentConditions(at coordinate: Coordinate, completion: @escaping (OpenWeatherCondition?, Error?) -> Void) {
        let params = ["lat": coordinate.latitude,
                      "lon": coordinate.longitude] as [String : Any]
        performRequest(to: OpenWeatherEndpoint.current, templateParameters: params, completion: completion)
    }
    
    func currentConditions(in city: String, completion: @escaping (OpenWeatherCondition?, Error?) -> Void) {
        let params = ["q": city] as [String : Any]
        performRequest(to: OpenWeatherEndpoint.current, templateParameters: params, completion: completion)
    }
}
