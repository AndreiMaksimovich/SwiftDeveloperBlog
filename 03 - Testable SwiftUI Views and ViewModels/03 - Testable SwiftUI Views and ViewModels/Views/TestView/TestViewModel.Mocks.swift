//
//  TestViewModel.Mocks.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 02/04/2026.
//

import Foundation
import Combine

@Observable
class TestViewModelMock: ITestViewModel {
    private let logTag = "SomeViewModelMock"
    
    private(set) var accelerometerData: AccelerometerData?
    private(set) var error: (any Error)?
    
    private let dataSource: AnyPublisherAccelerometerDataProvider
    private var subscription: AnyCancellable?
    
    init(dataSource: AnyPublisherAccelerometerDataProvider) {
        self.dataSource = dataSource
    }
        
    func onButtonTap_doSomeStuff() {
        print(logTag, "do some stuff")
    }
        
    func onAppear() {
        print(logTag, "onAppear")
        subscription = dataSource.sink(
            receiveCompletion: {completion in
                if case .failure(let error) = completion {
                    self.error = error
                }
            },
            receiveValue: {value in
                self.accelerometerData = value
            }
        )
    }
    
    func onDisappear() {
        print(logTag, "onDisappear")
        subscription?.cancel()
    }
}
