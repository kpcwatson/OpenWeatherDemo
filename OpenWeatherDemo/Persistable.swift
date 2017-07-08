//
//  Persistable.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/7/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

protocol Persistable {
    associatedtype Entity
    
    var allObjects: [Entity] { get }
    
    func add(_ entity: Entity)
    func remove(_ entity: Entity)
}

final class AnyPersistable<Entity>: Persistable {
    private let _allObjects: () -> [Entity]
    private let _add: (Entity) -> Void
    private let _remove: (Entity) -> Void
    
    var allObjects: [Entity] {
        return _allObjects()
    }
    
    init<P: Persistable>(_ delegatee: P) where P.Entity == Entity {
        _allObjects = { return delegatee.allObjects } // capture as closure
        _add = delegatee.add
        _remove = delegatee.remove
    }
    
    func add(_ entity: Entity) {
        _add(entity)
    }
    
    func remove(_ entity: Entity) {
        _remove(entity)
    }
}

//private class AnyPeristableBase<Entity>: Persistable {
//    init() {
//        guard type(of: self) != AnyPeristableBase.self else {
//            fatalError()
//        }
//    }
//    var allObjects: [Entity] { fatalError() }
//    func add(_ entity: Entity) { fatalError() }
//    func remove(_ entity: Entity) { fatalError() }
//}
//
//private final class AnyPersistableBox<Concrete: Persistable>: AnyPeristableBase<Concrete.Entity> {
//    var concrete: Concrete
//    init(_ concrete: Concrete) {
//        self.concrete = concrete
//    }
//    override var allObjects: [Concrete.Entity] {
//        return concrete.allObjects
//    }
//    override func add(_ entity: Concrete.Entity) {
//        concrete.add(entity)
//    }
//    override func remove(_ entity: Concrete.Entity) {
//        concrete.remove(entity)
//    }
//}
//
//final class AnyPersistable<Entity>: Persistable {
//    private let box: AnyPeristableBase<Entity>
//    init<Concrete: Persistable>(_ concrete: Concrete) where Concrete.Entity == Entity {
//        box = AnyPersistableBox(concrete)
//    }
//    var allObjects: [Entity] {
//        return box.allObjects
//    }
//    func add(_ entity: Entity) {
//        box.add(entity)
//    }
//    func remove(_ entity: Entity) {
//        box.remove(entity)
//    }
//}
