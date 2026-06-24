//
//  FoundationModelApp.swift
//  FoundationModel

import SwiftUI
import CoreData

@main
struct FoundationModelApp: App {

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .environment(LMManager.shared)
        .environment(SpeechRecognitionManager.shared)
    }
}
