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

public protocol Entity: class, CVarArg, NSObjectProtocol, PropertyType {
    
}

extension Entity {
    
    public static var properties: Property<Self> {
        return Property()
    }
}

public protocol PrimaryKeyEntity: Entity {
    
    associatedtype Key: PrimaryKey & PropertyType & CVarArg
    
    static var primaryKey: String { get }
}

extension Property where Value: PrimaryKeyEntity {
    
    var primaryKey: Property<Value.Key> {
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
