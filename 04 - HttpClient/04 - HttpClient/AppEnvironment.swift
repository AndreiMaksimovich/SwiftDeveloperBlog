//
//  AppEnvironment.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

import Foundation

@Observable
class AppEnvironment {
    
    private static var _shared: AppEnvironment?
    static var shared: AppEnvironment { _shared! }
    
    var demoApiClient: IDemoAPI
    
    init(demoApiClient: IDemoAPI) {
        self.demoApiClient = demoApiClient
    }
    
    static func initialize(_ appEnv: AppEnvironment) {
        _shared = appEnv
    }
}
