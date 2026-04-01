//
//  TestComplexValueView.swift
//  03 - Testable SwiftUI Views and ViewModels
//
//  Created by Andrei Maksimovich on 06/04/2026.
//

import SwiftUI

struct TestComplexViewValueSubview: View {
    
    @State var model: ITestComplexViewModel
    
    init(model: ITestComplexViewModel) {
        self.model = model
    }
    
    var body: some View {
        Text(model.someValue)
            .font(.title)
    }
}

#Preview {
    PreviewConatiner {
        TestComplexViewValueSubview(model: TestComplexViewModelMock())
    }
}
