//
//  DemoView.Types.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

import Foundation

enum DemoViewModelState {
    case notInitialized
    case loadingData
    case ready
    case error(error: Error)
}

protocol IDemoViewModel {
    var albums: [Album]? {get}
    var state: DemoViewModelState {get}
    func onAppear()
    func onDisappear()
    func refresh()
    func retry()
}
