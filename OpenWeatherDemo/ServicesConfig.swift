//
//  ServicesConfig.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

struct ServiceProperties {
    let host: String
    let endpoints: [String: String]
    
    var baseUrl: URL {
        // crashes if not a valid URL instead of leaving app in unstable state
        if host.contains("http") {
            return URL(string: host)!
        }
        return URL(string: "http://\(host)")!
    }
}

extension ServiceProperties: Mappable {
    init?(json: NSDictionary) {
        guard let host: String = json.value(for: "host"),
            let endpoints: [String: String] = json.value(for: "endpoints")
            else {
                return nil
        }
        
        self.host = host
        self.endpoints = endpoints
    }
}

enum ServiceName: String {
    case openWeather
}

enum ServicesConfigError: Error {
    case serviceNotFound
}

protocol ServicesConfigurable {
    func service(named: ServiceName) throws -> ServiceProperties
}

class ServicesConfigAdapter: ServicesConfigurable {
    
    private let config: Config
    
    init(config: Config) {
        self.config = config
    }
    
    func service(named name: ServiceName) throws -> ServiceProperties {
        guard let services = config["services"] as? NSDictionary,
            let service = services[name.rawValue] as? NSDictionary,
            let properties = ServiceProperties.from(service)
            else {
                throw ServicesConfigError.serviceNotFound
        }
        
        return properties
    }
}
