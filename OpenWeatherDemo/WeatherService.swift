//
//  WeatherService.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

typealias ForecastUpdateClosure = (CurrentCondition?, Error?) -> Void
typealias CompletionHandler = () -> Void

enum WeatherServiceError: Error {
    case OpenWeatherConditionIsNil
}

/// Facade that aggregates API clients.
class WeatherService {
    
    let weatherApiClient: OpenWeatherApiClient
    
    init(weatherApiClient: OpenWeatherApiClient) {
        self.weatherApiClient = weatherApiClient
    }
    
    // FIXME: remove duplicated code
    
    func currentForecasts(inEach cities: [String],
                          forecastUpdate: @escaping ForecastUpdateClosure,
                          complete: @escaping CompletionHandler) {
        
        let group = DispatchGroup()
        
        for city in cities {
            group.enter()
            
            weatherApiClient.currentConditions(in: city) { (owCondition, error) in
                guard error == nil else {
                    forecastUpdate(nil, error!)
                    group.leave()
                    return
                }
                
                guard let owCondition = owCondition else {
                    forecastUpdate(nil, WeatherServiceError.OpenWeatherConditionIsNil)
                    group.leave()
                    return
                }

                let responseAdapter = OpenWeatherResponseAdapter()
                let condition = responseAdapter.toCurrentCondition(owCondition, in: city)
                forecastUpdate(condition, nil)
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            Logger.debug("group notified")
            complete()
        }
    }
    
    func currentForecasts(atEach coordinates: [Coordinate],
                          forecastUpdate: @escaping ForecastUpdateClosure,
                          complete: @escaping CompletionHandler) {
        
        let group = DispatchGroup()
        
        for coordinate in coordinates {
            group.enter()
            
            weatherApiClient.currentConditions(at: coordinate) { (owCondition, error) in
                guard error == nil else {
                    forecastUpdate(nil, error!)
                    group.leave()
                    return
                }
                
                guard let owCondition = owCondition else {
                    forecastUpdate(nil, WeatherServiceError.OpenWeatherConditionIsNil)
                    group.leave()
                    return
                }
                
                let responseAdapter = OpenWeatherResponseAdapter()
                let condition = responseAdapter.toCurrentCondition(owCondition)
                forecastUpdate(condition, nil)
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            Logger.debug("group notified")
            complete()
        }
    }
}
