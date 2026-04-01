//
//  AppEnv.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 02/04/2026.
//

import Foundation
import Combine

@Observable
@MainActor
class AppEnvironment {
    private static var _shared: AppEnvironment?
    static var shared: AppEnvironment { _shared! }
    
    private(set) var dataProviders: any IAppDataProviders
    private(set) var services: any IAppServices
    
    init(dataProviders: any IAppDataProviders, services: any IAppServices) {
        self.dataProviders = dataProviders
        self.services = services
    }
    
    static func initialize(_ appEnv: AppEnvironment) {
        _shared = appEnv
    }
    
    static func teardown() {
        _shared = nil
    }
}

protocol IAppDataProviders {
    var accelerometerDataProvider: AnyPublisherAccelerometerDataProvider {get}
}

class AppDataProviders: IAppDataProviders {
    init(accelerometerDataProvider: AnyPublisherAccelerometerDataProvider) {
        self.accelerometerDataProvider = accelerometerDataProvider
    }
    var accelerometerDataProvider: AnyPublisherAccelerometerDataProvider
}

protocol IAppServices {}

class AppServices: IAppServices {}
