//
//  Dev.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 02/04/2026.
//

#if DEBUG

import SwiftUI

struct PreviewConatiner<Content: View>: View {
    @State var appEnvironment: AppEnvironment
    
    private let content: Content
    
    init(@ViewBuilder content: () -> Content, postInit: (() -> Void)? = nil) {
        initializeApp(mode: .preview, isSimulation: isSimulator, postInit: postInit)
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
