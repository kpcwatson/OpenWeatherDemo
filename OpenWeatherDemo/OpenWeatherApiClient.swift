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
    
    required init(serviceProperties: ServiceProperties, urlSession: URLSession = URLSession.shared) {
        super.init(serviceProperties: serviceProperties, urlSession: urlSession)
    }
    
    convenience init(urlSession: URLSession = URLSession.shared) {
        let services = ServicesConfigAdapter(config: GlobalConfig.shared.config)
        // crash because this puts the app in an unrecoverable state
        let service = try! services.service(named: .openWeather)
        self.init(serviceProperties: service, urlSession: urlSession)
    }
    
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
