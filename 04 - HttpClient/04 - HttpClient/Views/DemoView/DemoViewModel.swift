//
//  DemoViewModel.swift
//  04 - HttpClient
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

import Foundation

@Observable
class DemoViewModel: IDemoViewModel {
    private(set) var albums: [Album]?
    private(set) var state: DemoViewModelState = .notInitialized
    private var dataFetchTask: Task<Void, Never>?
    
    private let apiClient: any IDemoAPI
    
    init(apiClient: IDemoAPI) {
        self.apiClient = apiClient
    }
    
    init() {
        self.apiClient = AppEnvironment.shared.demoApiClient
    }
    
    func onAppear() {
        loadData()
    }
    
    func onDisappear() {
        if case .loadingData = state {
            dataFetchTask?.cancel()
            state = albums != nil ? .ready : .notInitialized
        }
    }
    
    func refresh() {
        loadData()
    }
    
    func retry() {
        loadData()
    }
    
    private func loadData() {
        state = .loadingData
        dataFetchTask?.cancel()
        dataFetchTask = Task {
            do {
                self.albums = try await self.apiClient.fetchAlbums()
                self.state = .ready
            } catch (let error) {
                self.state = .error(error: error)
            }
        }
    }
}
