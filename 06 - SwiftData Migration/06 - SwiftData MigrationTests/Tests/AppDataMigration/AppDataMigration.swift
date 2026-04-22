import Testing
@testable import _6___SwiftData_Migration
import SwiftData
import Foundation

@MainActor
@Suite(.serialized)
struct AppDataMigration {
    
    @Test func V01toV05fromFile() throws {
        try runAppDataMigrationTest(.init(
            setupStep: .init(versionedSchema: AppDataSchemaV01.self, migrationPlan: AppDataMigrationPlanV01.self, url: getModuleContainerUrlFromTestBundle("app-model-v01-container")!),
            test: .init(
                versionedSchema: AppDataSchemaV05.self,
                migrationPlan: AppDataMigrationPlanV05.self,
                validator: {(test, initialModelContainer, modelContainer) in
                    let initialContext = initialModelContainer.mainContext
                    let context = modelContainer.mainContext
                    
                    for initialPath in try initialContext.fetch(FetchDescriptor<AppDataSchemaV01.Path>()) {
                        let uid = initialPath.uid
                        let path = try context.fetch(FetchDescriptor<AppDataSchemaV05.Path>(predicate: #Predicate { $0.uid == uid })).first
                        #expect(path != nil)
                        #expect(path?.title == initialPath.title)
                    }
                    
                    let paths = try context.fetch(FetchDescriptor<AppDataSchemaV05.Path>())
                    #expect(paths.count == 1)
                    
                    let points = try context.fetch(FetchDescriptor<AppDataSchemaV05.PathPoint>())
                    points.forEach {point in
                        #expect(point.cell100 != nil)
                        #expect(point.cell1000 != nil)
                    }
                }
            )
        ))
    }
    
    @Test func V02toV05WithUpgradeStepFromV01() throws {
        try runAppDataMigrationTest(.init(
            setupStep: .init(versionedSchema: AppDataSchemaV01.self, migrationPlan: AppDataMigrationPlanV01.self, data: appDataMockDataSetV01),
            upgradeSteps: [
                .init(versionedSchema: AppDataSchemaV02.self, migrationPlan: AppDataMigrationPlanV02.self)
            ],
            test: .init(
                versionedSchema: AppDataSchemaV05.self,
                migrationPlan: AppDataMigrationPlanV05.self,
                validator: {(test, initialModelContainer, modelContainer) in
                    let initialContext = initialModelContainer.mainContext
                    let context = modelContainer.mainContext
            
                    for initialPath in try initialContext.fetch(FetchDescriptor<AppDataSchemaV01.Path>()) {
                        let uid = initialPath.uid
                        let path = try context.fetch(FetchDescriptor<AppDataSchemaV05.Path>(predicate: #Predicate { $0.uid == uid })).first
                        #expect(path != nil)
                        #expect(path?.title == initialPath.title)
                    }
                    
                    let paths = try context.fetch(FetchDescriptor<AppDataSchemaV05.Path>())
                    #expect(paths.count == 1)
                    
                    let points = try context.fetch(FetchDescriptor<AppDataSchemaV05.PathPoint>())
                    points.forEach {point in
                        #expect(point.cell100 != nil)
                        #expect(point.cell1000 != nil)
                    }
                }
            )
        ))
    }
    
    @Test func V03toV05() throws {
        try runAppDataMigrationTest(.init(
            setupStep: .init(versionedSchema: AppDataSchemaV03.self, migrationPlan: AppDataMigrationPlanV03.self, data: appDataMockDataSetV03),
            test: .init(
                versionedSchema: AppDataSchemaV05.self,
                migrationPlan: AppDataMigrationPlanV05.self,
                validator: {(test, initialModelContainer, modelContainer) in
                    let data = appDataMockDataSetV03
                    let srcPaths = data[AppDataSchemaV03.Path.typeId]!
                    
                    for _srcPath in srcPaths {
                        let srcPath = _srcPath as! AppDataSchemaV03.Path
                        let uid = srcPath.uid
                        let path = try modelContainer.mainContext.fetch(FetchDescriptor<AppDataSchemaV05.Path>(predicate: #Predicate {$0.uid == uid})).first!
                        #expect(srcPath.duration == path.duration)
                    }
                }
            )
        ))
    }
}
