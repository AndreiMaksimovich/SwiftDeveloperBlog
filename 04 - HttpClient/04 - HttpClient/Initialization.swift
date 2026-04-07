//
//  Initialization.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

import Foundation

enum AppRunMode {
    case production
    case qa
    case debug
    case preview
    case uiTesting
    case unitTesting
}

func initializeApp(runMode: AppRunMode = .production) {
    
    AppEnvironment.initialize(.init(demoApiClient: DemoAPIClient(httpClient: instantiateHttpClient(baseUrl: "https://jsonplaceholder.typicode.com/")!)))
}
