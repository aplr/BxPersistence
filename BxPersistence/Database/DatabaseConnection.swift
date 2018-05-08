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

public protocol DatabaseConnection: class {
    
    var context: Context { get }
    
    func read<E: Entity>(_ type: E.Type) -> Query<E>
    
    @discardableResult
    func create<E: Entity>(_ type: E.Type, _ execute: @escaping (Writable<E>) -> Void) -> DatabaseConnection
    @discardableResult
    func update<E: Entity>(_ entity: E, _ execute: @escaping (Writable<E>) -> Void) -> DatabaseConnection
    
    @discardableResult
    func delete<E: Entity>(_ entity: E) -> DatabaseConnection
}

extension DatabaseConnection {
    
    @discardableResult
    public func createOrUpdate<E: PrimaryKeyEntity & NSObject>(_ type: E.Type, with primaryKey: E.Key,
                                                               _ execute: @escaping (Writable<E>) -> Void) -> DatabaseConnection {
        if let object = self.read(type).filter(isIncluded: { $0.primaryKey == primaryKey }).first {
            return self.update(object, execute)
        }
        return self.create(type) { type in
            type.entity.setValue(primaryKey, forKey: E.primaryKey)
            execute(type)
        }
    }
    
    @discardableResult
    public func delete<S: Sequence>(_ entities: S) -> DatabaseConnection where S.Element: Entity {
        return entities.reduce(self) { $0.delete($1) }
    }
}
