//
//  utils.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 06/04/2026.
//

@testable import _3___Testable_SwiftUI_Views_and_ViewModels

@MainActor
func initTestEnvironment(postInit: (() -> Void)? = nil) {
    initializeApp(mode: .unitTesting, isSimulation: isSimulator, postInit: postInit)
}

@MainActor
func teardownTestEnvironment() {
    AppEnvironment.teardown()
}
