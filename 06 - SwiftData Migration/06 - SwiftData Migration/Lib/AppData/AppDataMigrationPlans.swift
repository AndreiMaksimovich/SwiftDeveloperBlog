//
//  AppDataMigrationPlans.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 24/04/2026.
//

import SwiftData
import Foundation

fileprivate nonisolated let migrateV1toV2 = MigrationStage.lightweight(fromVersion: AppDataSchemaV01.self, toVersion: AppDataSchemaV02.self)

fileprivate nonisolated let migrateV2toV3 = MigrationStage.custom(
    fromVersion: AppDataSchemaV02.self,
    toVersion: AppDataSchemaV03.self,
    willMigrate: nil,
    didMigrate: {context in
        let paths = try context.fetch(FetchDescriptor<AppDataSchemaV03.Path>())
        try paths.forEach {path in
            let pathPoints = try context.fetch(FetchDescriptor<AppDataSchemaV03.PathPoint>(
                predicate: #Predicate<AppDataSchemaV03.PathPoint> {point in point.longitude > 0},
                sortBy: [
                    .init(\AppDataSchemaV03.PathPoint.time, order: .reverse)
                ]
            ))
            if !pathPoints.isEmpty {
                path.duration = pathPoints.first!.time.timeIntervalSince(pathPoints.last!.time)
            } else {
                path.duration = 0
            }
        }
        
        let cellHelper100 = MapCellHelper(cellSize: 100)
        let cellHelper1000 = MapCellHelper(cellSize: 1000)
        
        let points = try context.fetch(FetchDescriptor<AppDataSchemaV03.PathPoint>())
        points.forEach {point in
            point.cell100 = cellHelper100.cell(longitude: point.longitude, lattitude: point.lattitude)
            point.cell1000 = cellHelper1000.cell(longitude: point.longitude, lattitude: point.lattitude)
        }
        
        try context.save()
    }
)

fileprivate nonisolated let migrateV3toV4 = MigrationStage.lightweight(fromVersion: AppDataSchemaV03.self, toVersion: AppDataSchemaV04.self)

fileprivate nonisolated let migrateV4toV5 = MigrationStage.lightweight(fromVersion: AppDataSchemaV04.self, toVersion: AppDataSchemaV05.self)

enum AppDataMigrationPlanV01: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [
        AppDataSchemaV01.self
    ]
    static let stages: [MigrationStage] = []
}

enum AppDataMigrationPlanV02: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [
        AppDataSchemaV01.self,
        AppDataSchemaV02.self
    ]
    static let stages: [MigrationStage] = [
        migrateV1toV2
    ]
}

enum AppDataMigrationPlanV03: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [
        AppDataSchemaV01.self,
        AppDataSchemaV02.self,
        AppDataSchemaV03.self,
    ]
    static let stages: [MigrationStage] = [
        migrateV1toV2,
        migrateV2toV3,
    ]
}

enum AppDataMigrationPlanV04: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [
        AppDataSchemaV01.self,
        AppDataSchemaV02.self,
        AppDataSchemaV03.self,
        AppDataSchemaV04.self,
    ]
    static let stages: [MigrationStage] = [
        migrateV1toV2,
        migrateV2toV3,
        migrateV3toV4,
    ]
}

enum AppDataMigrationPlanV05: SchemaMigrationPlan {
    static let schemas: [any VersionedSchema.Type] = [
        AppDataSchemaV01.self,
        AppDataSchemaV02.self,
        AppDataSchemaV03.self,
        AppDataSchemaV04.self,
        AppDataSchemaV05.self,
    ]
    static let stages: [MigrationStage] = [
        migrateV1toV2,
        migrateV2toV3,
        migrateV3toV4,
        migrateV4toV5,
    ]
}
