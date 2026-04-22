//
//  PersistentModelComparator.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 24/04/2026.
//

import SwiftData
import Foundation
@testable import _6___SwiftData_Migration


typealias EquatableDecodable = Equatable & Decodable

protocol IPersistentModelFieldComparator<Model> {
    associatedtype Model: PersistentModel
    func equal(model1: Model, model2: Model) -> Bool
}

protocol IPersistentModelComparator<Model> {
    associatedtype Model: PersistentModel
    func equal(model1: Model, model2: Model) -> Bool
}

struct PersistentModelFieldComparatorByValue<M: PersistentModel, T: EquatableDecodable>: IPersistentModelFieldComparator {
    typealias Model = M
    typealias Field = T
    
    let keyPath: KeyPath<Model, Field>
    func equal(model1: M, model2: M) -> Bool {
        model1.getValue(forKey: keyPath) == model2.getValue(forKey: keyPath)
    }
}

struct PersistentModelComparatorSimple<M: PersistentModel>: IPersistentModelComparator {
    typealias Model = M
    private let fieldComparators: [any IPersistentModelFieldComparator<M>]
    private let comparator: ((M, M) -> Bool)?
    
    init(_ fieldComparators: [any IPersistentModelFieldComparator<M>], comparator: ((M, M) -> Bool)? = nil) {
        self.fieldComparators = fieldComparators
        self.comparator = comparator
    }
    
    init(_ fieldComparators: any IPersistentModelFieldComparator<M>..., comparator: ((M, M) -> Bool)? = nil) {
        self.fieldComparators = fieldComparators
        self.comparator = comparator
    }
        
    func equal(model1: M, model2: M) -> Bool {
        for fieldComparator in fieldComparators {
            if !fieldComparator.equal(model1: model1, model2: model2) {
                return false
            }
        }
        if let comparator {
            return comparator(model1, model2)
        }
        return true
    }
    
    static func field<T: EquatableDecodable>(_ keyPath: KeyPath<M,T>) -> any IPersistentModelFieldComparator {
        PersistentModelFieldComparatorByValue(keyPath: keyPath)
    }
}
