//
//  AppEnvironment.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 14/04/2026.
//


import Foundation
import SwiftData

@Observable
class AppEnvironment {
    private static var _shared: AppEnvironment?
    static var shared: AppEnvironment { _shared! }
    
    let modelContainer: ModelContainer
    let locationAuthorizationManager: any ILocationAuthorizationManager
    let backgroundLocationDataProvider: any IBackgroundLocationDataProvider
    let pathRecordManager: any IPathRecordManager
    
    init(
        modelContainer: ModelContainer,
        locationAuthorizationManager: any ILocationAuthorizationManager,
        pathRecordManager: any IPathRecordManager,
        backgroundLocationDataProvider: any IBackgroundLocationDataProvider)
    {
        self.modelContainer = modelContainer
        self.locationAuthorizationManager = locationAuthorizationManager
        self.pathRecordManager = pathRecordManager
        self.backgroundLocationDataProvider = backgroundLocationDataProvider
    }
    
    static func initialize(modelContainer: ModelContainer, locationAuthorizationManager: any ILocationAuthorizationManager, pathRecordManager: any IPathRecordManager) {
        _shared = AppEnvironment(modelContainer: modelContainer, locationAuthorizationManager: locationAuthorizationManager, pathRecordManager: pathRecordManager, backgroundLocationDataProvider: BackgroundLocationDataProvider())
    }
}
