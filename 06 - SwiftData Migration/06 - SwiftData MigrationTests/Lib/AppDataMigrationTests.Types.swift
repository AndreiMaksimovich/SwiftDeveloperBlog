//
//  AppDataMigrationTest.Types.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 24/04/2026.
//

import SwiftData
import Foundation
@testable import _6___SwiftData_Migration

typealias AppDataMockDataSet = [AnyHashable: [any PersistentModel]]
typealias AppDataValidator = (_ test: AppDataMigrationTest, _ initialModel: ModelContainer, _ model: ModelContainer) throws -> Void

struct AppDataMigrationTest {
    let setupStep: SetupStep
    let upgradeSteps: [UpgradeStep]
    let test: Test
    
    init(setupStep: SetupStep, upgradeSteps: [UpgradeStep] = [], test: Test) {
        self.setupStep = setupStep
        self.upgradeSteps = upgradeSteps
        self.test = test
    }
    
    struct SetupStep {
        let versionedSchema: any VersionedSchema.Type
        let migrationPlan: (any SchemaMigrationPlan.Type)?
        let data: AppDataMockDataSet?
        let url: URL?
        let setupAction: ((ModelContainer) -> Void)?
        init(
            versionedSchema: any VersionedSchema.Type,
            migrationPlan: (any SchemaMigrationPlan.Type)? = nil,
            data: AppDataMockDataSet? = nil, url: URL? = nil,
            setupAction: ((ModelContainer) -> Void)? = nil,
        ) {
            self.versionedSchema = versionedSchema
            self.migrationPlan = migrationPlan
            self.data = data
            self.url = url
            self.setupAction = setupAction
        }
    }

    struct UpgradeStep {
        let versionedSchema: any VersionedSchema.Type
        let migrationPlan: (any SchemaMigrationPlan.Type)
        let setupAction: ((ModelContainer) -> Void)?
        init(
            versionedSchema: any VersionedSchema.Type,
            migrationPlan: any SchemaMigrationPlan.Type,
            setupAction: ((ModelContainer) -> Void)? = nil
        ) {
            self.versionedSchema = versionedSchema
            self.migrationPlan = migrationPlan
            self.setupAction = setupAction
        }
    }

    struct Test {
        let versionedSchema: any VersionedSchema.Type
        let migrationPlan: any SchemaMigrationPlan.Type
        let validator: AppDataValidator
        let expectedData: AppDataMockDataSet?
        
        init(
            versionedSchema: any VersionedSchema.Type,
            migrationPlan: (any SchemaMigrationPlan.Type),
            validator: @escaping AppDataValidator,
            expectedData: AppDataMockDataSet? = nil)
        {
            self.versionedSchema = versionedSchema
            self.migrationPlan = migrationPlan
            self.validator = validator
            self.expectedData = expectedData
        }
    }
}
