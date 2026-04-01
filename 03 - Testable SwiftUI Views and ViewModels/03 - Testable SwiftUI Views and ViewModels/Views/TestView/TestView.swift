//
//  ContentView.swift
//  03 - Testable SwiftUI Views and ViewModels
//
//  Created by Andrei Maksimovich on 01/04/2026.
//

import SwiftUI
import DynamicPublisher
import Combine
import CoreMotion

struct TestView: View {
    @State var model: any ITestViewModel
    
    init(model: any ITestViewModel) {
        self.model = model
    }
    
    init () {
        self.model = TestViewModel()
    }
    
    var body: some View {
        VStack {
            
            if let accelerometerData = model.accelerometerData {
                Text(accelerometerData.debugString)
            }
            
            if let error = model.error {
                Text("**ERROR:**")
                    .foregroundStyle(.red)
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
            }
            
            Button("Do some stuff") {
                model.onButtonTap_doSomeStuff()
            }
            
            NavigationLink(destination: { SecondView() }, label: { Text("Open Second View") })
        }
        .padding()
        .onAppear {
            print("onAppear")
            model.onAppear()
        }
        .onDisappear {
            print("onDisappear")
            model.onDisappear()
        }
        .onFirstAppear {
            print("onFirstAppear")
        }
    }
}

#Preview("Env") {
    PreviewConatiner {
        TestView()
    }
}

#Preview("Prod") {
    // Will fail with no accelerometer error unless is previewed on a real device
    PreviewConatiner {
        TestView(model: TestViewModel(dataSource: AccelerometerDataProvider.shared.eraseToAnyPublisher()))
    }
}

#Preview("Normal Model, Mock Data") {
    PreviewConatiner {
        TestView(
            model: TestViewModel(dataSource: AccelerometerDataProviderMock().eraseToAnyPublisher())
        )
    }
}

#Preview("Mock Model & Data") {
    PreviewConatiner {
        TestView(
            model: TestViewModelMock(dataSource: AccelerometerDataProviderMock().eraseToAnyPublisher())
        )
    }
}

#Preview("Normal Model, No accelerometer") {
    PreviewConatiner {
        TestView(
            model: TestViewModel(dataSource: AccelerometerDataProviderMockNoAccelerometer().eraseToAnyPublisher())
        )
    }
}
