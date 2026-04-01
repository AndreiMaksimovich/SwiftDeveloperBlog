import SwiftUI

#if targetEnvironment(simulator)
    let isSimulator = true
#else
    let isSimulator = false
#endif

#if DEBUG
    let isDebug = true
#else
    let isDebug = false
#endif

let isPreview = ProcessInfo.isPreview

let isUITesting = CommandLine.arguments.contains("--uitesting")

let appRunMode: AppRunMode = isUITesting ? .uiTesting : isPreview ? .preview : isDebug ? .debug : .production

@main
struct TestableViewsApp: App {
    @State var appEnvironment: AppEnvironment
    
    init() {
        initializeApp(mode: appRunMode, isSimulation: isSimulator)
        appEnvironment = AppEnvironment.shared
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
            }
            .environment(appEnvironment)
        }
    }
}
