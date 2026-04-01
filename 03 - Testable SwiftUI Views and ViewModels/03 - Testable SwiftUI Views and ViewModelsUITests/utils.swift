//
//  utils.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 02/04/2026.
//

import XCTest

@MainActor
func getConfiguredXCUIApplicationInstance() -> XCUIApplication {
    let app = XCUIApplication()
    app.launchArguments.append("--uitesting")
    return app
}
