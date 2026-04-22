//
//  ModelContainerUtils.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 24/04/2026.
//

import SwiftData
import Foundation
@testable import _6___SwiftData_Migration

fileprivate class TestClass {}

@MainActor
func getModuleContainerUrlFromTestBundle(_ forResource: String) -> URL? {
    return Bundle(for: TestClass.self).url(forResource: forResource, withExtension: nil)
}

func getModelContainerFiles(_ url: URL) -> [URL] {
    return [
        url,
        URL(string: "\(url.absoluteString)-shm")!,
        URL(string: "\(url.absoluteString)-wal")!,
    ]
}

@MainActor
func removeModelContainer(_ url: URL) throws {
    try FileManager.default.removeFiles(getModelContainerFiles(url))
}

@MainActor
func copyModelContainer(src: URL, dst: URL) throws {
    try removeModelContainer(dst)
    let srcFiles = getModelContainerFiles(src)
    let dstFiles = getModelContainerFiles(dst)
    
    for i in 0..<srcFiles.count {
        let srcFile = srcFiles[i]
        let dstFile = dstFiles[i]
        try FileManager.default.copyItem(at: srcFile, to: dstFile)
    }
}

@MainActor
func initializeAppDataMockModelContainer(
    url: URL,
    erase: Bool = true,
    versionedSchema: any VersionedSchema.Type,
    migrationPlan: (any SchemaMigrationPlan.Type)? = nil,
    data: AppDataMockDataSet?
) throws -> ModelContainer {
    if erase {
        try removeModelContainer(url)
    }
    
    let modelContainer = try ModelContainer(for: .init(versionedSchema: versionedSchema), migrationPlan: migrationPlan, configurations: [.init(url: url)])
    
    // Data
    if let data {
        let context = modelContainer.mainContext
        for (_, dataSet) in data {
            for instance in dataSet {
                context.insert(instance)
            }
        }
        try context.save()
    }
    
    return modelContainer
}

@MainActor
func openModelContainer(url: URL, versionedSchema: any VersionedSchema.Type, migrationPlan: (any SchemaMigrationPlan.Type)?) throws -> ModelContainer {
    return try ModelContainer(for: .init(versionedSchema: versionedSchema), migrationPlan: migrationPlan, configurations: [.init(url: url)])
}
