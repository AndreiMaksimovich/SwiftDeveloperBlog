//
//  AccelerometerDataProvider.Mocks.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 02/04/2026.
//

import DynamicPublisher
import CoreMotion

class AccelerometerDataProviderMock: DynamicPublisherAccelerometerDataProvider {
    private var task: Task<Void, Never>?
    
    override func start() {
        task = Task {
            while (true) {
                if Task.isCancelled {
                    return
                }
                self.send(.init(x: Double.random(in: 0...1), y: Double.random(in: 0...1), z: Double.random(in: 0...1)))
                try? await Task.sleep(for: .seconds(0.5))
            }
        }
    }
    
    override func stop() {
        task?.cancel()
    }
}

class AccelerometerDataProviderMockNoAccelerometer: DynamicPublisherAccelerometerDataProvider {
    override func start() {
        fail(with: .accelerometerNotAvailable)
    }
}
