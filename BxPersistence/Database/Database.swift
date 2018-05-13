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

public protocol Database {
    
    var connection: DatabaseConnection { get }
    var model: Model { get }
    
    func slimIfNeeded()
    func delete()
}

extension Database {
    
    public func slimIfNeeded() {
        return
    }
    
    public func assertValidEntity(_ entity: Entity.Type) {
        assert(self.model.entities.contains { $0 == entity },
               "Database does not manage entity \(entity).")
    }
}
