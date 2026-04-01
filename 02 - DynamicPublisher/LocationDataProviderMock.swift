//
//  LocationDataProviderMock.swift
//
//  Created by Andrei Maksimovich on 29/03/2026.
//

import MapKit
import Combine
import Foundation
import DynamicPublisher

class LocationDataProviderMock: DynamicPublisher<CLLocation, LocationDataProviderError> {
    static let shared = LocationDataProviderMock()
        
    private var task: Task<Void, Never>?
    
    override func start() {
        task = Task {
            while true {
                try? await Task.sleep(for: .seconds(1))
                if Task.isCancelled { return }
                send(CLLocation(latitude: CLLocationDegrees.random(in: -90...90), longitude: CLLocationDegrees.random(in: -180...180)))
            }
        }
    }
    
    override func stop() {
        task?.cancel()
    }
    
}
