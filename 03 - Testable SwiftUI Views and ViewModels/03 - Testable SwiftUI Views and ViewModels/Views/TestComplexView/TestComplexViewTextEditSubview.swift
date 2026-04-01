//
//  TestComplexEditSubview.swift
//  03 - Testable SwiftUI Views and ViewModels
//
//  Created by Andrei Maksimovich on 06/04/2026.
//

import SwiftUI

struct TestComplexViewTextEditSubview: View {
    
    @State var model: ITestComplexViewModel
    
    init(model: ITestComplexViewModel) {
        self.model = model
    }
    
    var body: some View {
        TextEditor(text: .init(get: {model.someValue}, set: {model.setSomeValue($0)}))
            .padding(5)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary, lineWidth: 2))
            .padding()
    }
}

#Preview {
    PreviewConatiner {
        TestComplexViewTextEditSubview(model: TestComplexViewModelMock())
    }
}
