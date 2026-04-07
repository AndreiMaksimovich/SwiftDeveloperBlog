//
//  DemoViewModelMock.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

import Foundation

fileprivate let demoViewModelMockData: [Album] = [
    .init(userId: 1, id: 2, title: "Title 1/2"),
    .init(userId: 3, id: 4, title: "Title 3/4"),
    .init(userId: 5, id: 6, title: "Title 5/6")
]

enum DemoViewModelMockBehaviour {
    case mockData
    case errorState
    case loadingState
}

@Observable
class DemoViewModelMock: IDemoViewModel {
    private let logTag = "DemoViewModelMock"
    
    private(set) var albums: [Album]? = nil
    private(set) var state: DemoViewModelState = .notInitialized
    private let behaviour: DemoViewModelMockBehaviour
    
    init(behaviour: DemoViewModelMockBehaviour) {
        self.behaviour = behaviour
    }
    
    func onAppear() {
        print(logTag, "onAppear", behaviour)
        switch behaviour {
            case .mockData:
                self.albums = demoViewModelMockData
                self.state = .ready
                break
            case .errorState:
                self.state = .error(error: HttpClientError.incorrectResponseType)
                break
            case .loadingState:
                self.state = .loadingData
                break
        }
    }
        
    func onDisappear() {
        print(logTag, "onDisappear", behaviour)
    }
    
    func refresh() {
        print(logTag, "refresh", behaviour)
    }
    
    func retry() {
        print(logTag, "retry", behaviour)
    }
}
