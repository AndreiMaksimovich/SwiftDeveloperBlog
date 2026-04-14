import SwiftUI
import SwiftData

@main
struct BackgroundLocationApp: App {
    @State var appDataModelContainer: ModelContainer
    @State var appEnvironment: AppEnvironment
    @State var appNavigator = AppNavigator.shared
    
    init() {
        let modelContainer = instantiateAppDataModelContainer(isStoredInMemoryOnly: false)
        self.appDataModelContainer = modelContainer
        AppEnvironment.initialize(
            modelContainer: modelContainer,
            locationAuthorizationManager: LocationAuthorizationManager(),
            pathRecordManager: PathRecordManager(modelContext: modelContainer.mainContext)
        )
        self.appEnvironment = AppEnvironment.shared
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appNavigator.path) {
                RootView()
                    .navigationDestination(for: AppNavigationDestination.self, destination: getAppNavigationDestination)
            }
        }
        .modelContainer(appDataModelContainer)
        .environment(appEnvironment)
        .environment(appNavigator)
    }
}
