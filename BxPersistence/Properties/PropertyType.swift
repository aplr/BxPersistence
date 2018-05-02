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

public protocol PropertyType {
    
    static var argsIdentifier: String { get }
}

extension Int: PropertyType {
    
    public static var argsIdentifier: String {
        return "%d"
    }
}

extension Int32: PropertyType {
    
    public static var argsIdentifier: String {
        return "%d"
    }
}

extension Int16: PropertyType {
    
    public static var argsIdentifier: String {
        return "%d"
    }
}

extension Int8: PropertyType {
    
    public static var argsIdentifier: String {
        return "%d"
    }
}

extension Bool: PropertyType {
    
    public static var argsIdentifier: String {
        return "%d"
    }
}

extension Int64: PropertyType {
    
    public static var argsIdentifier: String {
        return "%lld"
    }
}

extension Double: PropertyType {
    
    public static var argsIdentifier: String {
        return "%f"
    }
}

extension Float: PropertyType {
    
    public static var argsIdentifier: String {
        return "%f"
    }
}

extension String: PropertyType {
    
    public static var argsIdentifier: String {
        return "%@"
    }
}

extension Date: PropertyType {
    
    public static var argsIdentifier: String {
        return "%@"
    }
}

extension Data: PropertyType {
    
    public static var argsIdentifier: String {
        return "%@"
    }
}

extension Optional: PropertyType where Wrapped: PropertyType {
    
    public static var argsIdentifier: String {
        return Wrapped.argsIdentifier
    }
}

extension Entity {
    
    public static var argsIdentifier: String {
        return "%@"
    }
}

extension Set: PropertyType where Element: Entity {
    
    public static var argsIdentifier: String {
        return "%@"
    }
}
