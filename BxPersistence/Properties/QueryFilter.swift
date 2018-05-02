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

public struct QueryFilter<T> {

    public let predicate: NSPredicate
    
    internal init(predicate: NSPredicate) {
        self.predicate = predicate
    }
    
    internal init<U>(_ casting: QueryFilter<U>) {
        self.predicate = casting.predicate
    }

    public static func && (lhs: QueryFilter<T>, rhs: QueryFilter<T>) -> QueryFilter<T> {
        return QueryFilter(predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [lhs.predicate,
                                                                                            rhs.predicate]))
    }

    public static func || (lhs: QueryFilter<T>, rhs: QueryFilter<T>) -> QueryFilter<T> {
        return QueryFilter(predicate: NSCompoundPredicate(orPredicateWithSubpredicates: [lhs.predicate,
                                                                                           rhs.predicate]))
    }

    public static prefix func ! (lhs: QueryFilter<T>) -> QueryFilter<T> {
        return QueryFilter(predicate: NSCompoundPredicate(notPredicateWithSubpredicate: lhs.predicate))
    }
}

public func == <V, R>(property: Property<V>, value: V) -> QueryFilter<R> where V: Equatable & CVarArg & PropertyType {
    return QueryFilter(predicate: NSPredicate(format: "\(property.label) == \(V.argsIdentifier)", value))
}

public func != <V, R>(property: Property<V>, value: V) -> QueryFilter<R> where V: Equatable & CVarArg & PropertyType {
    return !QueryFilter(predicate: NSPredicate(format: "\(property.label) == \(V.argsIdentifier)", value))
}

public func >= <V, R>(property: Property<V>, value: V) -> QueryFilter<R> where V: Comparable & CVarArg & PropertyType {
    return QueryFilter(predicate: NSPredicate(format: "\(property.label) >= \(V.argsIdentifier)", value))
}

public func <= <V, R>(property: Property<V>, value: V) -> QueryFilter<R> where V: Comparable & CVarArg & PropertyType {
    return QueryFilter(predicate: NSPredicate(format: "\(property.label) <= \(V.argsIdentifier)", value))
}

public func < <V, R>(property: Property<V>, value: V) -> QueryFilter<R> where V: Comparable & CVarArg & PropertyType {
    return QueryFilter(predicate: NSPredicate(format: "\(property.label) < \(V.argsIdentifier)", value))
}

public func > <V, R>(property: Property<V>, value: V) -> QueryFilter<R> where V: Comparable & CVarArg & PropertyType {
    return QueryFilter(predicate: NSPredicate(format: "\(property.label) > \(V.argsIdentifier)", value))
}

extension Property where Value: Equatable {
    
    public func isMember<C: Collection, R>(of collection: C) -> QueryFilter<R> where C.Element == Value {
        let args = collection.map { _ in Value.argsIdentifier }.joined(separator: ",")
        return QueryFilter(predicate: NSPredicate(format: "\(self.label) IN {\(args)}",
                             argumentArray: Array(collection)))
    }
}

extension Property where Value: Comparable & CVarArg {
    
    public func isBetween<R>(_ lowerBound: Value, and upperBound: Value) -> QueryFilter<R> {
        let format = "\(self.label) BETWEEN {\(Value.argsIdentifier), \(Value.argsIdentifier)}"
        return QueryFilter(predicate: NSPredicate(format: format,
                             lowerBound, upperBound))
    }
}

extension Property where Value == String {
    
    public func beginsWith<R>(_ string: String, caseInsensitive: Bool = false) -> QueryFilter<R> {
        let trait = caseInsensitive ? "[c]" : ""
        return QueryFilter(predicate: NSPredicate(format: "\(self.label) BEGINSWITH\(trait) %@", string))
    }
    
    public func endsWith<R>(_ string: String, caseInsensitive: Bool = false) -> QueryFilter<R> {
        let trait = caseInsensitive ? "[c]" : ""
        return QueryFilter(predicate: NSPredicate(format: "\(self.label) ENDSWITH\(trait) %@", string))
    }
    
    public func contains<R>(_ string: String, caseInsensitive: Bool = false) -> QueryFilter<R> {
        let trait = caseInsensitive ? "[c]" : ""
        return QueryFilter(predicate: NSPredicate(format: "\(self.label) CONTAINS\(trait) %@", string))
    }
    
    public func isLike<R>(_ string: String, caseInsensitive: Bool = false) -> QueryFilter<R> {
        let trait = caseInsensitive ? "[c]" : ""
        return QueryFilter(predicate: NSPredicate(format: "\(self.label) LIKE\(trait) %@", string))
    }
}

extension Property where Value == Optional<String> {
    
    public func beginsWith<R>(_ string: String, caseInsensitive: Bool = false) -> QueryFilter<R> {
        let trait = caseInsensitive ? "[c]" : ""
        return QueryFilter(predicate: NSPredicate(format: "\(self.label) BEGINSWITH\(trait) %@", string))
    }
    
    public func endsWith<R>(_ string: String, caseInsensitive: Bool = false) -> QueryFilter<R> {
        let trait = caseInsensitive ? "[c]" : ""
        return QueryFilter(predicate: NSPredicate(format: "\(self.label) ENDSWITH\(trait) %@", string))
    }
    
    public func contains<R>(_ string: String, caseInsensitive: Bool = false) -> QueryFilter<R> {
        let trait = caseInsensitive ? "[c]" : ""
        return QueryFilter(predicate: NSPredicate(format: "\(self.label) CONTAINS\(trait) %@", string))
    }
    
    public func isLike<R>(_ string: String, caseInsensitive: Bool = false) -> QueryFilter<R> {
        let trait = caseInsensitive ? "[c]" : ""
        return QueryFilter(predicate: NSPredicate(format: "\(self.label) LIKE\(trait) %@", string))
    }
}

extension Property where Value: Collection, Value.Element: Entity {

    public func contains<R>(_ element: Value.Element) -> QueryFilter<R> {
        return QueryFilter(predicate: NSPredicate(format: "ANY \(self.label) == %@", element))
    }

    public func contains<R>(where predicate: (Property<Value.Element>) -> QueryFilter<R>) -> QueryFilter<R> {
        let attribute = Property<Value.Element>(relativeTo: self)
        let filter = predicate(attribute).predicate.predicateFormat
        return QueryFilter(predicate: NSPredicate(format: "ANY \(filter)"))
    }
}

