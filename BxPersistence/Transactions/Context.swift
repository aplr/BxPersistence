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
import BxReact

public struct Context {
    
    private let transactions: [Transaction]
    private let context: (() -> Void) -> Void
    
    public init<S: Sequence>(transactions: S, context: @escaping (() -> Void) -> Void) where S.Element == Transaction {
        self.transactions = Array(transactions)
        self.context = context
    }
    
    @discardableResult
    public func commit() -> Single<[Entity]> {
        return Single.create { single in
            self.context {
                var result = [Entity?]()
                do {
                    try self.transactions.forEach {
                        result.append(try $0.commit())
                    }
                    single(.success(result.compactMap { $0 }))
                } catch {
                    single(.error(error))
                }
            }
            return Disposables.create()
        }.trigger()
    }
}
