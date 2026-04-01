//
//  AccelerometerDataProvider.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 02/04/2026.
//

import DynamicPublisher
import CoreMotion

class AccelerometerDataProvider: DynamicPublisherAccelerometerDataProvider  {
    static let shared = AccelerometerDataProvider()
    
    private let motionManager: CMMotionManager = .init()
    private let accelerometerUpdateInterval = 1/30.0
    
    override init() {
        super.init()
        motionManager.accelerometerUpdateInterval = accelerometerUpdateInterval
    }
    
    override func start() {
        guard motionManager.isAccelerometerAvailable else {
            fail(with: .accelerometerNotAvailable)
            return
        }
        
        motionManager.startAccelerometerUpdates(to: .main) {(data, error) in
            if let error {
                self.fail(with: .accelerometerError(error: error))
                return
            }
            
            if let data {
                self.send(.from(data: data))
            }
        }
    }
    
    override func stop() {
        motionManager.stopAccelerometerUpdates()
    }
}
