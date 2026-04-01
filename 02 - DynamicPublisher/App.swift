import SwiftUI

@main
struct DynamicPublisherApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LocationDataProviderTestView()
            }
        }
    }
}
