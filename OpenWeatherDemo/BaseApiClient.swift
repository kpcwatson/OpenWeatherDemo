//
//  BaseApiClient.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

enum ApiClientError: Error {
    case missingEndpointTemplate(named: String)
    case noResponseData
    case invalidJson
    case mappingFailed
}

class BaseApiClient {
    
    private let urlSession: URLSession
    private let serviceProperties: ServiceProperties
    
    init(urlSession: URLSession, serviceProperties: ServiceProperties) {
        self.urlSession = urlSession
        self.serviceProperties = serviceProperties
    }
    
    // callback hell-ish... would prefer RxSwift to return Observable but I am
    // limiting 3rd-party library usage.
    func performRequest<M: Mappable>(to endpointName: String,
                        templateParameters: [String: Any] = [:],
                        completion: @escaping (M?, Error?) -> Void) {
        
        guard let endpoint = serviceProperties.endpoints[endpointName] else {
            let error = ApiClientError.missingEndpointTemplate(named: endpointName)
            completion(nil, error)
            return
        }
        
        let request: URLRequest
        do {
            request = try RequestBuilder(baseUrl: serviceProperties.baseUrl)
                .httpMethod(.GET)
                .pathTemplate(endpoint)
                .templateParameters(templateParameters)
                .build()
        } catch {
            completion(nil, error)
            return
        }
        
        urlSession.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, ApiClientError.noResponseData)
                return
            }
            
            do {
                guard let json = try JSONSerialization
                    .jsonObject(with: data, options: []) as? NSDictionary else {
                        completion(nil, ApiClientError.invalidJson)
                        return
                }
                
                guard let conditions = M.from(json) else {
                    completion(nil, ApiClientError.mappingFailed)
                    return
                }
                
                completion(conditions, nil)
            } catch {
                completion(nil, error)
            }
        }
        .resume()
    }
}
