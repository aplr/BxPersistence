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

import RxSwift
import BxReact

extension ObservableType where E: Collection, E.Index == Int, E.Element: Equatable {
    
    private func queryCollection(for collection: E) -> QueryCollection<E.Element> {
        return .init(AnyQueryCollectionType(numberOfSections: { 1 },
                                            numberOfItemsInSection: { _ in collection.count },
                                            objectAtIndexPath: { collection[$0.row] }))
    }
    
    public func elements() -> Observable<QueryChange<E.Element>> {
        return Observable<QueryChange<E.Element>>
            .create { observer in
                return self.withUpdate()
                    .subscribe(onNext: { old, new in
                        guard let old = old else {
                            observer.onNext(.initial(self.queryCollection(for: new)))
                            return
                        }
                        let diff = Dwifft.diff(Array(old), Array(new))
                        var insertions = [IndexPath]()
                        var deletions = [IndexPath]()
                        diff.forEach {
                            switch $0 {
                            case .insert(let index, _): insertions.append(IndexPath(item: index, section: 0))
                            case .delete(let index, _): deletions.append(IndexPath(item: index, section: 0))
                            }
                        }
                        let description = QueryChangeDescription(sectionInsertions: [], sectionDeletions: [],
                                                                 insertions: insertions, deletions: deletions,
                                                                 modifications: [])
                        observer.onNext(.change(self.queryCollection(for: new), description: description))
                    }, onError: observer.onError,
                       onCompleted: observer.onCompleted)
            }
    }
}

extension ObservableType where E: Collection, E.Element: SectionType, E.Element.Element: Equatable, E.Index == Int {
    
    private func queryCollection(for collection: E) -> QueryCollection<E.Element.Element> {
        return .init(AnyQueryCollectionType(numberOfSections: { collection.count },
                                            numberOfItemsInSection: { collection[$0].count },
                                            objectAtIndexPath: { collection[$0.section].elements[$0.row] }))
    }
    
    public func elements() -> Observable<QueryChange<E.Element.Element>> {
        return Observable<QueryChange<E.Element.Element>>
            .create { observer in
                return self.withUpdate()
                    .subscribe(onNext: { old, new in
                        guard let old = old else {
                            observer.onNext(.initial(self.queryCollection(for: new)))
                            return
                        }
                        let oldSections = SectionedValues(old.map { ($0, $0.elements)})
                        let newSections = SectionedValues(new.map { ($0, $0.elements)})
                        let diff = Dwifft.diff(lhs: oldSections, rhs: newSections)
                        var insertions = [IndexPath]()
                        var deletions = [IndexPath]()
                        var sectionInsertions = IndexSet()
                        var sectionDeletions = IndexSet()
                        diff.forEach {
                            switch $0 {
                            case .insert(let section, let item, _):
                                insertions.append(IndexPath(item: item, section: section))
                            case .delete(let section, let item, _):
                                deletions.append(IndexPath(item: item, section: section))
                            case .sectionInsert(let section, _):
                                sectionInsertions.insert(section)
                            case .sectionDelete(let section, _):
                                sectionDeletions.insert(section)
                            }
                        }
                        let description = QueryChangeDescription(sectionInsertions: sectionInsertions,
                                                                 sectionDeletions: sectionDeletions,
                                                                 insertions: insertions,
                                                                 deletions: deletions,
                                                                 modifications: [])
                        observer.onNext(.change(self.queryCollection(for: new), description: description))
                    }, onError: observer.onError,
                       onCompleted: observer.onCompleted)
            }
    }
}

