//
//  RootView.swift
//  03 - Testable SwiftUI Views and ViewModels
//
//  Created by Andrei Maksimovich on 06/04/2026.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        VStack {
            NavigationLink(destination: { TestView() }, label: { Text("Simple View") })
            NavigationLink(destination: { TestComplexView() }, label: { Text("Complex View") })
            
if isUITesting {
    Button("Custom UITesting Button") {
        print("Hello UITesting")
    }
}
        }
    }
}

#Preview {
    print(appRunMode)
    return PreviewConatiner {
        RootView()
    }
}
