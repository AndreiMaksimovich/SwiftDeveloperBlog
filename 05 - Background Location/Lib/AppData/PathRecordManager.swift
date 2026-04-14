//
//  PathDataManager.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 14/04/2026.
//

import SwiftData
import Foundation

protocol IPathRecordManager {
    func delete(_ record: PathRecord)
    func insert(record: PathRecord)
}

class PathRecordManager: IPathRecordManager {
    private let logTag = "PathRecordManager"
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func insert(record: PathRecord) {
        print(logTag, "insert", record)
        modelContext.insert(record)
    }
        
    func delete(_ record: PathRecord) {
        print(logTag, "delete", record)
        modelContext.delete(record)
    }
}
