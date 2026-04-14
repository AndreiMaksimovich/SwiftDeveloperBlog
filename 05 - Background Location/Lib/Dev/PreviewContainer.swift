//
//  PreviewContainer.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 14/04/2026.
//

#if DEBUG

import SwiftUI
import SwiftData

struct PreviewConatiner<Content: View>: View {
    @State var modelContainer: ModelContainer
    @State var appEnvironemnt: AppEnvironment
    @State var appNavigationManager = AppNavigator.shared
    
    private let content: Content
    
    init(@ViewBuilder content: () -> Content, postInit: (() -> Void)? = nil) {
        let modelContainer = instantiateAppDataModelContainer(isStoredInMemoryOnly: true)
        insertMockData(modelContext: modelContainer.mainContext)
        self.modelContainer = modelContainer
        AppEnvironment.initialize(
            modelContainer: modelContainer,
            locationAuthorizationManager: LocationAuthorizationManager(),
            pathRecordManager: PathRecordManager(modelContext: modelContainer.mainContext)
        )
        self.appEnvironemnt = AppEnvironment.shared
        self.content = content()
        
        print("Init preview")
        
    }
    
    var body: some View {
        NavigationStack(path: $appNavigationManager.path) {
            content
                .navigationDestination(for: AppNavigationDestination.self, destination: getAppNavigationDestination)
        }
        .modelContainer(modelContainer)
        .environment(appEnvironemnt)
        .environment(appNavigationManager)
        
    }
}

#endif
