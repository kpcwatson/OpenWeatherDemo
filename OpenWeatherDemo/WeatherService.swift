//
//  WeatherService.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

typealias CityForecastUpdateClosure = (String, CurrentCondition?, Error?) -> Void
typealias CoordinateForecastUpdateClosure = (Coordinate, CurrentCondition?, Error?) -> Void
typealias CompletionHandler = () -> Void

enum WeatherServiceError: Error {
    case OpenWeatherConditionIsNil
}

/// Facade that aggregates API clients.
class WeatherService {
    
    let weatherApiClient: OpenWeatherApiClient
    
    init(weatherApiClient: OpenWeatherApiClient = OpenWeatherApiClient()) {
        self.weatherApiClient = weatherApiClient
    }
    
    // FIXME: remove duplicated code
    
    // FIXME: add content repository with expiry
    
    func currentForecasts(inEach cities: [String],
                          onForecastUpdated forecastUpdated: @escaping CityForecastUpdateClosure,
                          onComplete complete: @escaping CompletionHandler) {
        
        let group = DispatchGroup()
        
        for city in cities {
            group.enter()
            
            weatherApiClient.currentConditions(in: city) { (owCondition, error) in
                guard error == nil else {
                    forecastUpdated(city, nil, error!)
                    group.leave()
                    return
                }
                
                guard let owCondition = owCondition else {
                    forecastUpdated(city, nil, WeatherServiceError.OpenWeatherConditionIsNil)
                    group.leave()
                    return
                }

                let responseAdapter = OpenWeatherResponseAdapter()
                let condition = responseAdapter.toCurrentCondition(owCondition, in: city)
                forecastUpdated(city, condition, nil)
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            complete()
        }
    }
    
    func currentForecasts(atEach coordinates: [Coordinate],
                          onForecastUpdated forecastUpdated: @escaping CoordinateForecastUpdateClosure,
                          onComplete complete: @escaping CompletionHandler) {
        
        let group = DispatchGroup()
        
        for coordinate in coordinates {
            group.enter()
            
            weatherApiClient.currentConditions(at: coordinate) { (owCondition, error) in
                guard error == nil else {
                    forecastUpdated(coordinate, nil, error!)
                    group.leave()
                    return
                }
                
                guard let owCondition = owCondition else {
                    forecastUpdated(coordinate, nil, WeatherServiceError.OpenWeatherConditionIsNil)
                    group.leave()
                    return
                }
                
                let responseAdapter = OpenWeatherResponseAdapter()
                let condition = responseAdapter.toCurrentCondition(owCondition)
                forecastUpdated(coordinate, condition, nil)
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            complete()
        }
    }
}
