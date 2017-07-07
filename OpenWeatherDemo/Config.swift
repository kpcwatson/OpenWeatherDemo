//
//  Config.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

typealias Config = [String: Any]

class GlobalConfig {
    static let shared = GlobalConfig()
    
    lazy var config: Config = {
        guard let url = Bundle.main.url(forResource: "config", withExtension: "json"),
            let data = try? Data.init(contentsOf: url, options: .mappedIfSafe),
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let config = json as? Config
            else {
                fatalError("config could not be loaded")
        }
        return config
    }()
    
    private init() {}
}
