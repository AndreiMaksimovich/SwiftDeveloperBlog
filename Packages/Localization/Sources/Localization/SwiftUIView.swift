//
//  SwiftUIView.swift
//  Localization
//
//  Created by Andrei Maksimovich on 23/03/2026.
//

import SwiftUI

public struct SwiftUIView: View {
    
    public init() {}
    
    public var body: some View {
        return VStack {
            Text(.helloWorld)
            Text(.SecondCatalog.helloWorld)
            Text(.helloWorldUserName(userName: "SomeName"))
            
            Spacer().frame(height: 10)
            
            Text("HelloWorld", bundle: .module)
            Text("HelloWorld", tableName: "SecondCatalog", bundle: .module)
            Text(String(format: String(localized: "HelloWorldUserName", bundle: .module), "SomeName"))
            
            Text(.TestCatalog.test)
            
        }
        .padding()
        
    }
}

#Preview("en") {
    SwiftUIView()
        .environment(\.locale, .init(identifier: "en"))
}

#Preview("be") {
    SwiftUIView()
        .environment(\.locale, .init(identifier: "be"))
}
