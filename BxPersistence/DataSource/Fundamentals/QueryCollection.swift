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

public struct QueryCollection<E> {
    
    private let collection: QueryCollectionType
    
    internal init<O>(_ collection: QueryCollection<O>) {
        self.collection = collection.collection
    }
    
    internal init(_ collection: QueryCollectionType) {
        self.collection = collection
    }
    
    public var numberOfSections: Int {
        return collection.numberOfSections
    }
    
    public func numberOfItems(in section: Int) -> Int {
        return collection.numberOfItems(in: section)
    }
    
    public func object(at indexPath: IndexPath) -> E {
        return collection.object(at: indexPath) as! E
    }
}
