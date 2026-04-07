import SwiftUI

@main
struct HttpClientApp: App {
    
    @State var appEnvironment: AppEnvironment
    
    init() {
        initializeApp(runMode: .production)
        self.appEnvironment = AppEnvironment.shared
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DemoView()
            }
            .environment(appEnvironment)
        }
    }
}
