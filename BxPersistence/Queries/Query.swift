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

public class Query<E: Entity> {
    
    private let base: QueryType
    private var sequence: Observable<QueryChange<E>>?
    
    public init(_ base: QueryType) {
        self.base = base
    }
    
    public var count: Int {
        return base.count
    }
    
    public var first: E? {
        if let first = base.first {
            let result = first as! E
            return result
        }
        return nil
    }
    
    public var last: E? {
        if let last = base.last {
            let result = last as! E
            return result
        }
        return nil
    }
    
    public func filter(isIncluded predicate: (Property<E>) -> QueryFilter<E>) -> Query<E> {
        return Query(base.filter(with: QueryFilter(predicate(E.properties))))
    }
    
    public func sorted<C: Comparable>(ascending: Bool = true, by property: (Property<E>) -> Property<C>) -> Query<E> {
        return Query(base.sort(by: property(E.properties), ascending: ascending))
    }
    
    public func distinct<C: Comparable>(by property: (Property<E>) -> Property<C>) -> Query<E> {
        return Query(base.distinct(by: property(E.properties)))
    }
    
    public func fetch() -> [E] {
        return base.fetch() as! [E]
    }
    
    public func sum<A: Addable>(of property: (Property<E>) -> Property<A>) -> A {
        return base.sum(of: property(E.properties))
    }
    
    public func min<M: Comparable>(of property: (Property<E>) -> Property<M>) -> M? {
        return base.min(of: property(E.properties))
    }
    
    public func max<M: Comparable>(of property: (Property<E>) -> Property<M>) -> M? {
        return base.max(of: property(E.properties))
    }
    
    public func index(matching predicate: (Property<E>) -> QueryFilter<E>) -> Int? {
        return base.index(matching: QueryFilter(predicate(E.properties)))
    }
    
    public func index(of element: E) -> Int? {
        return base.index(of: element)
    }
    
    public subscript(index: Int) -> E {
        return base[index] as! E
    }
    
    public func elements() -> Observable<QueryChange<E>> {
        if let sequence = self.sequence {
            return sequence
        } else {
            let sequence = base.observedElements
                .map { QueryChange<E>($0) }
                .share()
                .subscribeOn(MainScheduler.instance)
                .observeOn(MainScheduler.instance)
            self.sequence = sequence
            return sequence
        }
    }
}

extension Query: Sequence {
    
    public func makeIterator() -> QueryIterator<E> {
        return .init(base.iterator)
    }
}

extension Query: QueryCollectionType {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return count
    }
    
    func object(at indexPath: IndexPath) -> Any {
        return self[indexPath.row]
    }
}
