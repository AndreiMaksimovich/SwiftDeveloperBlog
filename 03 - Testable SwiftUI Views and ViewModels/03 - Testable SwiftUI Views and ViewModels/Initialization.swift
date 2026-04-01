//
//  Initialization.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 02/04/2026.
//

import Combine

func initializeApp(mode: AppRunMode, isSimulation: Bool, postInit: (() -> Void)? = nil) {
        
    let accelerometerDataProvider: AnyPublisherAccelerometerDataProvider = switch (mode) {
        case .production, .debug, .uiTesting:
            isSimulation ? AccelerometerDataProviderMock().eraseToAnyPublisher() : AccelerometerDataProvider.shared.eraseToAnyPublisher()
        case .preview, .unitTesting:
            AccelerometerDataProviderMock().eraseToAnyPublisher()
    }
    
    AppEnvironment.initialize(.init(dataProviders: AppDataProviders(accelerometerDataProvider: accelerometerDataProvider), services: AppServices()))
    
    postInit?()
}
