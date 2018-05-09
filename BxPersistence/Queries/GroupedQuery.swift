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

public class GroupedQuery<E: Entity> {
    
    private let base: Query<E>
    private let groupStarts: Query<E>
    
    internal init<C: Comparable>(_ base: Query<E>, _ property: (Property<E>) -> Property<C>) {
        self.base = base.sorted(by: property)
        self.groupStarts = self.base.distinct(by: property)
    }
    
    public subscript(indexPath: IndexPath) -> E {
        let startEntity = groupStarts[indexPath.section]
        let index = base.index(of: startEntity)!
        return base[index + indexPath.row]
    }
    
    private func indexPath(for index: Int) -> IndexPath {
        var section = 0
        while section < groupStarts.count {
            if section + 1 >= groupStarts.count {
                break
            }
            let entity = groupStarts[section]
            let entityIndex = base.index(of: entity)!
            let successor = groupStarts[section + 1]
            let successorIndex = base.index(of: successor)!
            if entityIndex..<successorIndex ~= index {
                break
            }
            section += 1
        }
        let entity = groupStarts[section]
        return IndexPath(row: index - base.index(of: entity)!, section: section)
    }
}
