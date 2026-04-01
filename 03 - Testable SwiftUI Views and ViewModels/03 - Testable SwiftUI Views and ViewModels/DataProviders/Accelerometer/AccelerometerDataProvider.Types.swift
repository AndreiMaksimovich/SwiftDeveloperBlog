//
//  AccelerometerDataProvider.Types.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 02/04/2026.
//

import SwiftUI
import DynamicPublisher
import Combine
import CoreMotion

typealias DynamicPublisherAccelerometerDataProvider = DynamicPublisher<AccelerometerData, AccelerometerDataProviderError>
typealias AnyPublisherAccelerometerDataProvider = AnyPublisher<AccelerometerData, AccelerometerDataProviderError>

struct AccelerometerData {
    let x: Double
    let y: Double
    let z: Double
    
    init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    static func from(data: CMAccelerometerData) -> Self {
        .init(x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z)
    }
    
    var debugString: String {
        "x: \(x),\n y: \(y),\n z: \(z)\n"
    }
}

enum AccelerometerDataProviderError: Error {
    case accelerometerNotAvailable
    case accelerometerError(error: any Error)
}
