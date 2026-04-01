//
//  TestComplexView.swift
//  03 - Testable SwiftUI Views and ViewModels
//
//  Created by Andrei Maksimovich on 06/04/2026.
//

import SwiftUI

struct TestComplexView: View {
    @State var model: ITestComplexViewModel
    
    init(model: ITestComplexViewModel) {
        self.model = model
    }
    
    init () {
        self.model = TestComplexViewModel()
    }
    
    var body: some View {
        VStack {
            TestComplexViewValueSubview(model: model)
            TestComplexViewTextEditSubview(model: model)
        }
    }
}

#Preview("Default") {
    PreviewConatiner {
        TestComplexView()
    }
}

#Preview("Mock") {
    PreviewConatiner {
        TestComplexView(model: TestComplexViewModelMock())
    }
}
