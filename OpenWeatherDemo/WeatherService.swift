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
class WeatherService: ExpirableRepositoryBackedService {
    
    let contentRepository: CurrentConditionRepository
    let weatherApiClient: OpenWeatherApiClient
    
    init(contentRepository: CurrentConditionRepository = CurrentConditionRepository(),
         weatherApiClient: OpenWeatherApiClient = OpenWeatherApiClient()) {
        
        self.contentRepository = contentRepository
        self.weatherApiClient = weatherApiClient
    }
    
    func currentConditions(forEach cities: [String],
                          onForecastUpdated forecastUpdated: @escaping CityForecastUpdateClosure,
                          onComplete complete: @escaping CompletionHandler) {
        
        let group = DispatchGroup()
        
        if contentRepository.isContentExpired {
            contentRepository.removeAll()
        }
        
        for city in cities {
            group.enter()
            
            guard !contentRepository.contains(city) else {
                Logger.debug("from repo for \(city)")
                let currentCondition = contentRepository.first(for: city)!
                forecastUpdated(city, currentCondition, nil)
                group.leave()
                continue
            }
            
            Logger.debug("updating from origin \(city)")
            weatherApiClient.currentConditions(in: city) { [weak self] (owCondition, error) in
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
                
                self?.contentRepository.add(condition)
                forecastUpdated(city, condition, nil)
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            complete()
        }
    }
}
