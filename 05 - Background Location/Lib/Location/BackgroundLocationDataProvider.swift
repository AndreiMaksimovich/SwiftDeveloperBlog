//
//  BackgroundLocationDataProvider.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 16/04/2026.
//

import DynamicPublisher
import CoreLocation
import Combine

public enum BackgroundLocationDataProviderError: Error {
    case notAuthorized
    case locationManagerError(error: Error)
}

public protocol IBackgroundLocationDataProvider {
    var backgroundLocationPublisher: AnyPublisher<CLLocation, BackgroundLocationDataProviderError> {get}
}

public class BackgroundLocationDataProvider: DynamicPublisher<CLLocation, BackgroundLocationDataProviderError>, CLLocationManagerDelegate, IBackgroundLocationDataProvider {
    
    private let locationManager: CLLocationManager = .init()
    private var backgroundActivitySession: CLBackgroundActivitySession?
    
    public var backgroundLocationPublisher: AnyPublisher<CLLocation, BackgroundLocationDataProviderError> {
        eraseToAnyPublisher()
    }
    
    public override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
    }
    
    override public func start() {
        guard [.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus) else {
            fail(with: .notAuthorized)
            return
        }
        
        locationManager.startUpdatingLocation()
        backgroundActivitySession = .init()
    }
    
    override public func stop() {
        locationManager.startUpdatingLocation()
        backgroundActivitySession?.invalidate()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            send(location)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        fail(with: .locationManagerError(error: error))
    }
}
