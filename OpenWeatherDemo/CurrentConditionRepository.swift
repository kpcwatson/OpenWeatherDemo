//
//  CurrentConditionRepository.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/7/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

let defaultRefreshInterval: TimeInterval = 300

protocol ExpirableRepositoryBackedService: class {
    var contentRepository: CurrentConditionRepository { get }
}

class CurrentConditionRepository {
    var contents = [CurrentCondition]()
    
    var isContentExpired: Bool {
        guard let lastModified = lastModified else {
            return true
        }
        
        let expireDate = Date(timeInterval: refreshInterval, since: lastModified)
        return expireDate < Date()
    }
    
    var isEmpty: Bool {
        return self.contents.isEmpty
    }
    
    private let refreshInterval: TimeInterval
    private var lastModified: Date?
    
    init(refreshInterval: TimeInterval = defaultRefreshInterval) {
        self.refreshInterval = refreshInterval
    }
    
    func add(_ content: CurrentCondition) {
        contents.append(content)
        resetLastModifiedDate()
    }
    
    func remove(_ content: CurrentCondition) -> CurrentCondition? {
        guard let index = contents.index(of: content) else {
            return nil
        }
        
        let removed = contents.remove(at: index)
        resetLastModifiedDate()
        return removed
    }
    
    func removeAll() {
        contents.removeAll()
        resetLastModifiedDate()
    }
    
    func contains(_ city: String) -> Bool {
        return contents.contains { $0.city == city }
    }
    
    func first(for city: String) -> CurrentCondition? {
        return contents.first { $0.city == city }
    }
    
    private func resetLastModifiedDate() {
        lastModified = Date()
    }
}
