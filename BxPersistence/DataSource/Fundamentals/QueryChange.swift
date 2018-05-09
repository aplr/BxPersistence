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

import UIKit

public enum QueryChange<Element> {
    
    case initial(QueryCollection<Element>)
    case change(QueryCollection<Element>, description: QueryChangeDescription)
    case error(Error)
    
    internal init<E>(_ change: QueryChange<E>) {
        switch change {
        case .initial(let collection):
            self = .initial(.init(collection))
        case .change(let collection, description: let description):
            self = .change(.init(collection), description: description)
        case .error(let error):
            self = .error(error)
        }
    }
}

public struct QueryChangeDescription {
    
    public let sectionInsertions: IndexSet
    public let sectionDeletions: IndexSet
    public let insertions: [IndexPath]
    public let deletions: [IndexPath]
    public let modifications: [IndexPath]
    
    public init(sectionInsertions: IndexSet, sectionDeletions: IndexSet,
                insertions: [IndexPath], deletions: [IndexPath], modifications: [IndexPath]) {
        self.sectionInsertions = sectionInsertions
        self.sectionDeletions = sectionDeletions
        self.insertions = insertions
        self.deletions = deletions
        self.modifications = modifications
    }
}
