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

public class FakeDatabaseConnection: DatabaseConnection {
    
    public init() {
        
    }
    
    public func read<E>(_ type: E.Type) -> Query<E> where E: Entity {
        return Query(FakeQueryType())
    }
    
    public func create<E>(_ type: E.Type, andReturn: Bool,
                          _ execute: @escaping (Writable<E>) -> Void) -> DatabaseConnection where E: Entity {
        return self
    }
    
    public func update<E>(_ entity: E, andReturn: Bool,
                          _ execute: @escaping (Writable<E>) -> Void) -> DatabaseConnection where E: Entity {
        return self
    }
    
    public func delete<E>(_ entity: E) -> DatabaseConnection where E: Entity {
        return self
    }
    
    public func commit() -> Single<[Entity]> {
        return Single.just([])
    }
}
