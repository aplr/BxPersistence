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
import BxUtility

fileprivate var observerContext: UInt8 = 0

public protocol Entity: class, CVarArg, NSObjectProtocol, PropertyType {
    
    init()
    var observedProperties: Observable<[PropertyChange]> { get }
}

extension Entity {
    
    public static var properties: Property<Self> {
        return Property()
    }
}

extension Entity where Self: NSObject {
    
    public func observable<T>(for property: (Property<Self>) -> Property<T>) -> Observable<T> {
        var sequence: Observable<[PropertyChange]>
        if let stored = objc_getAssociatedObject(self, &observerContext) as? Observable<[PropertyChange]> {
            sequence = stored
        } else {
            sequence = observedProperties
                .share()
                .subscribeOn(MainScheduler.instance)
                .observeOn(MainScheduler.instance)
            objc_setAssociatedObject(self, &observerContext, sequence, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        let name = property(Self.properties).label
        return sequence
            .filter { changes in changes.contains { $0.name == name } }
            .map { $0.first?.newValue as? T }
            .filterNil()
            .startWith(value(forKeyPath: name) as! T)
    }
}

public protocol PrimaryKeyEntity: Entity {
    
    associatedtype Key: PrimaryKey & PropertyType & CVarArg
    
    static var primaryKey: String { get }
}

extension Property where Value: PrimaryKeyEntity {
    
    public var primaryKey: Property<Value.Key> {
        return Property<Value.Key>(Value.primaryKey, relativeTo: self)
    }
}

public protocol PrimaryKey: Equatable {
    
}

extension UUID: PrimaryKey { }
extension String: PrimaryKey { }
extension Int64: PrimaryKey { }
extension UInt64: PrimaryKey { }
extension Int32: PrimaryKey { }
extension UInt32: PrimaryKey { }
extension Int16: PrimaryKey { }
extension UInt16: PrimaryKey { }
extension Int8: PrimaryKey { }
extension UInt8: PrimaryKey { }
