//
//  PreviewContainer.swift
//  SwiftDeveloperBlog
//

#if DEBUG

import SwiftUI

struct PreviewConatiner<Content: View>: View {
    private let content: Content
    
    init(@ViewBuilder content: () -> Content, postInit: (() -> Void)? = nil) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
        }
        .environment(LMManager.shared)
        .environment(SpeechRecognitionManager.shared)
        
    }
}

#endif
