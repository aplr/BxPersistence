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

public protocol QueryType {
    
    var count: Int { get }
    var first: Entity? { get }
    var last: Entity? { get }
    
    var iterator: AnyIterator<Entity> { get }
    var observedElements: Observable<QueryChange<Entity>> { get }
    
    func filter(with queryFilter: QueryFilter<Entity>) -> QueryType
    func sort<C: Comparable>(by property: Property<C>, ascending: Bool) -> QueryType
    func distinct<C: Comparable>(by property: Property<C>) -> QueryType
    func fetch() -> [Entity]
    
    func sum<A: Addable>(of property: Property<A>) -> A
    func min<M: Comparable>(of property: Property<M>) -> M?
    func max<M: Comparable>(of property: Property<M>) -> M?
    
    func index(matching predicate: QueryFilter<Entity>) -> Int?
    func index(of element: Entity) -> Int?
    
    subscript(index: Int) -> Entity { get }
}
