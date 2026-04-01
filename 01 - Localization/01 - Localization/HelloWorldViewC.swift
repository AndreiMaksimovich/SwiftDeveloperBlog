//
//  SwiftUIView.swift
//  Blog 01 - Localization
//
//  Created by Andrei Maksimovich on 22/03/2026.
//

import SwiftUI

struct HelloWorldViewC: View {
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("HelloWorld")
            Text("HelloWorld", bundle: .main)
            Text(LocalizedStringResource.helloWorld)
            Text(LocalizedStringResource.c_helloWorld)
        }
    }
}

#Preview("EN") {
    HelloWorldViewC()
        .environment(\.locale, .init(identifier: "en"))
        .padding()
}

#Preview("BE") {
    HelloWorldViewC()
        .environment(\.locale, .init(identifier: "be"))
        .padding()
}

#Preview("PL") {
    HelloWorldViewC()
        .environment(\.locale, .init(identifier: "pl"))
        .padding()
}

#Preview("UK") {
    HelloWorldViewC()
        .environment(\.locale, .init(identifier: "uk"))
        .padding()
}
