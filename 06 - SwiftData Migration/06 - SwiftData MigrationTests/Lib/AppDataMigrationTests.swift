//
//  AppDataMigrationTesting.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 26/04/2026.
//

import Testing
@testable import _6___SwiftData_Migration
import SwiftData
import Foundation

let defaultAppDataMockModelContainerUrl = URL.documentsDirectory.appending(path: "app-model-container")
let defaultTmpAppDataMockModelContainerUrl = URL.documentsDirectory.appending(path: "tmp-app-model-container")


@MainActor
func runAppDataMigrationTest(_ migrationTest: AppDataMigrationTest) throws {
    // Setup
    do {
        let setupStep = migrationTest.setupStep
        
        if setupStep.url != nil {
            try copyModelContainer(src: setupStep.url!, dst: defaultAppDataMockModelContainerUrl)
        }
        
        let modelContainer = try initializeAppDataMockModelContainer(url: defaultAppDataMockModelContainerUrl, erase: setupStep.url == nil, versionedSchema: setupStep.versionedSchema.self, data: migrationTest.setupStep.data)
        
        if let setupAction = setupStep.setupAction {
            setupAction(modelContainer)
            try modelContainer.mainContext.save()
        }
    }
    
    // Upgrade steps
    for upgradeStep in migrationTest.upgradeSteps {
        let modelContainer = try openModelContainer(url: defaultAppDataMockModelContainerUrl, versionedSchema: upgradeStep.versionedSchema, migrationPlan: upgradeStep.migrationPlan)
        
        if let setupAction = upgradeStep.setupAction {
            setupAction(modelContainer)
            try modelContainer.mainContext.save()
        }
    }
    
    try copyModelContainer(src: defaultAppDataMockModelContainerUrl, dst: defaultTmpAppDataMockModelContainerUrl)
    
    // Test
    do {
        let test = migrationTest.test
        let initialContainerModel = try openModelContainer(url: defaultTmpAppDataMockModelContainerUrl, versionedSchema: migrationTest.setupStep.versionedSchema.self, migrationPlan: migrationTest.setupStep.migrationPlan)
        let modelContainer = try openModelContainer(url: defaultAppDataMockModelContainerUrl, versionedSchema: test.versionedSchema, migrationPlan: test.migrationPlan)
        try test.validator(migrationTest, initialContainerModel, modelContainer)
    }
}
