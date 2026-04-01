//
//  SwiftUIView.swift
//  A
//
//  Created by Andrei Maksimovich on 22/03/2026.
//

import SwiftUI
import Localization

public struct HelloWorldViewA: View {
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("HelloWorld")
            Text(.Public.helloWorld)
            Text(LocalizedStringResource.helloWorld)
        }
    }
}

#Preview("EN") {
    HelloWorldViewA()
        .environment(\.locale, .init(identifier: "en"))
        .padding()
}

#Preview("BE") {
    HelloWorldViewA()
        .environment(\.locale, .init(identifier: "be"))
        .padding()
}

#Preview("PL") {
    HelloWorldViewA()
        .environment(\.locale, .init(identifier: "pl"))
        .padding()
}

#Preview("UK") {
    HelloWorldViewA()
        .environment(\.locale, .init(identifier: "uk"))
        .padding()
}
