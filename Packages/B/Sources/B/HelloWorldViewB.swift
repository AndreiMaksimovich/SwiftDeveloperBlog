//
//  SwiftUIView.swift
//  B
//
//  Created by Andrei Maksimovich on 22/03/2026.
//

import SwiftUI
import A

public struct HelloWorldViewB: View {
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("HelloWorld")
            Text("HelloWorld", bundle: .b)
            Text(LocalizedStringResource.helloWorld)
            Text(LocalizedStringResource.b_helloWorld)
        }
    }
}


#Preview("EN") {
    HelloWorldViewB()
        .environment(\.locale, .init(identifier: "en"))
        .padding()
}

#Preview("BE") {
    HelloWorldViewB()
        .environment(\.locale, .init(identifier: "be"))
        .padding()
}

#Preview("PL") {
    HelloWorldViewB()
        .environment(\.locale, .init(identifier: "pl"))
        .padding()
}

#Preview("UK") {
    HelloWorldViewB()
        .environment(\.locale, .init(identifier: "uk"))
        .padding()
}
