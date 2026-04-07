//
//  PreviewConatiner.swift
//  04 - HttpClient
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

#if DEBUG

import SwiftUI

struct PreviewConatiner<Content: View>: View {
    @State var appEnvironment: AppEnvironment
    
    private let content: Content
    
    init(@ViewBuilder content: () -> Content, postInit: (() -> Void)? = nil) {
        initializeApp(runMode: .preview)
        self.appEnvironment = AppEnvironment.shared
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            content
        }
        .environment(appEnvironment)
    }
}

#endif
