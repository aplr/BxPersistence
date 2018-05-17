// Copyright 2018 Oliver Borchert
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import RxSwift
import BxReact

public protocol DatabaseConnection: class {
    
    func read<E: Entity>(_ type: E.Type) -> Query<E>
    
    @discardableResult
    func create<E: Entity>(_ type: E.Type, andReturn: Bool, _ execute: @escaping (Writable<E>) -> Void) -> DatabaseConnection
    @discardableResult
    func update<E: Entity>(_ entity: E, andReturn: Bool, _ execute: @escaping (Writable<E>) -> Void) -> DatabaseConnection
    
    @discardableResult
    func delete<E: Entity>(_ entity: E) -> DatabaseConnection
    
    @discardableResult
    func commit() -> Single<[Entity]>
}

extension DatabaseConnection {
    
    @discardableResult
    public func createOrUpdate<E: PrimaryKeyEntity & NSObject>(_ type: E.Type, with primaryKey: E.Key, andReturn: Bool = true,
                                                               _ execute: @escaping (Writable<E>) -> Void) -> DatabaseConnection {
        if let object = self.read(type).filter(isIncluded: { $0.primaryKey == primaryKey }).first {
            return self.update(object, andReturn: andReturn, execute)
        }
        return self.create(type, andReturn: andReturn) { type in
            type.entity.setValue(primaryKey, forKey: E.primaryKey)
            execute(type)
        }
    }
    
    @discardableResult
    public func create<E: Entity>(_ type: E.Type, _ execute: @escaping (Writable<E>) -> Void) -> DatabaseConnection {
        return self.create(type, andReturn: true, execute)
    }
    
    @discardableResult
    func update<E: Entity>(_ entity: E, _ execute: @escaping (Writable<E>) -> Void) -> DatabaseConnection {
        return self.update(entity, andReturn: true, execute)
    }
    
    @discardableResult
    public func delete<S: Sequence>(_ entities: S) -> DatabaseConnection where S.Element: Entity {
        return entities.reduce(self) { $0.delete($1) }
    }
    
    @discardableResult
    public func commit(on scheduler: SchedulerType) -> Single<[Entity]> {
        return commit().subscribeOn(scheduler)
    }
    
    public func commit<R>(on scheduler: SchedulerType? = nil,
                          expect: R.Type = R.self) -> Single<R> {
        return (scheduler.map { self.commit(on: $0) } ?? self.commit())
            .map { $0.first as? R }
            .asObservable().unwrap().asSingle()
    }
    
    public func commit<R>(on scheduler: SchedulerType? = nil,
                          expectCollectionOf: R.Type = R.self) -> Single<[R]> {
        return (scheduler.map { self.commit(on: $0) } ?? self.commit())
            .map { $0 as? [R] }
            .asObservable().unwrap().asSingle()
    }
}
