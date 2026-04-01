//
//  ContentView.swift
//  Blog 01 - Localization
//
//  Created by Andrei Maksimovich on 22/03/2026.
//

import SwiftUI
import A
import B
import Localization

struct ContentView: View {
    
    @State var localeId: String = "en"
    
    var body: some View {
        List {
            
            Picker("Locale", selection: $localeId) {
                ForEach(["en", "be", "pl", "uk"], id: \.self) {id in
                    Text(id).tag(id).id(id)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 200)
            
            Text("test_string_key", bundle: .main)
            Text(String(localized: "test_string_key \("Hello")"))
            
            Text("some.test.id")
            Text("some.test.id \("123")")
            
            SwiftUIView()
            
            VStack(alignment: .leading) {
                Text("A")
                    .font(.headline)
                HelloWorldViewA()
            }
            
            VStack(alignment: .leading) {
                Text("B")
                    .font(.headline)
                HelloWorldViewB()
            }
            
            VStack(alignment: .leading) {
                Text("C")
                    .font(.headline)
                HelloWorldViewC()
            }
        }
        .padding()
        .environment(\.locale, .init(identifier: localeId))
    }
}

#Preview {
    ContentView()
}
