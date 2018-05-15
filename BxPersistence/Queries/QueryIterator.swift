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

public struct QueryIterator<E>: IteratorProtocol {
    
    private var iterator: AnyIterator<Any>
    
    internal init<I: IteratorProtocol>(_ base: I) {
        var base = base
        iterator = AnyIterator {
            base.next()
        }
    }
    
    public mutating func next() -> E? {
        if let next = iterator.next() {
            let result = next as! E
            return result
        }
        return nil
    }
}
