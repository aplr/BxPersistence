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
import BxUtility
import RxSwift

public struct FakeQueryType: QueryType {
    
    public var count: Int {
        return 0
    }
    
    public var first: Entity? {
        return nil
    }
    
    public var last: Entity? {
        return nil
    }
    
    public var iterator: AnyIterator<Entity> {
        return AnyIterator { nil }
    }
    
    public var observedElements: Observable<QueryChange<Entity>> {
        return Observable.empty()
    }
    
    public func filter(with queryFilter: QueryFilter<Entity>) -> QueryType {
        return self
    }
    
    public func sort<C: Comparable>(by property: Property<C>, ascending: Bool) -> QueryType {
        return self
    }
    
    public func distinct<C: Comparable>(by property: Property<C>) -> QueryType {
        return self
    }
    
    public func fetch() -> [Entity] {
        return []
    }
    
    public func sum<A: Addable>(of property: Property<A>) -> A {
        return 0
    }
    
    public func min<M: Comparable>(of property: Property<M>) -> M? {
        return nil
    }
    
    public func max<M: Comparable>(of property: Property<M>) -> M? {
        return nil
    }
    
    public func index(matching predicate: QueryFilter<Entity>) -> Int? {
        return nil
    }
    
    public func index(of element: Entity) -> Int? {
        return nil
    }
    
    public subscript(index: Int) -> Entity {
        fatalError()
    }
}
