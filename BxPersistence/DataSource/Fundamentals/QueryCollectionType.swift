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

internal protocol QueryCollectionType {
    
    var numberOfSections: Int { get }
    func numberOfItems(in section: Int) -> Int
    func object(at indexPath: IndexPath) -> Any
}

internal struct AnyQueryCollectionType: QueryCollectionType {
    
    private let _numberOfSections: () -> Int
    private let _numberOfItemsInSection: (Int) -> Int
    private let _objectAtIndexPath: (IndexPath) -> Any
    
    init(numberOfSections: @escaping () -> Int,
         numberOfItemsInSection: @escaping (Int) -> Int,
         objectAtIndexPath: @escaping (IndexPath) -> Any) {
        self._numberOfSections = numberOfSections
        self._numberOfItemsInSection = numberOfItemsInSection
        self._objectAtIndexPath = objectAtIndexPath
    }
    
    var numberOfSections: Int {
        return _numberOfSections()
    }
    
    func numberOfItems(in section: Int) -> Int {
        return _numberOfItemsInSection(section)
    }
    
    func object(at indexPath: IndexPath) -> Any {
        return _objectAtIndexPath(indexPath)
    }
}
