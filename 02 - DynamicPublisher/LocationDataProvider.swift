//
//  LocationDataProvider.swift
//
//  Created by Andrei Maksimovich on 29/03/2026.
//

import MapKit
import Combine
import DynamicPublisher

enum LocationDataProviderError: Error {
    case authorizedDenied
    case locationManagerError(error: any Error)
}

class LocationDataProvider: DynamicPublisher<CLLocation, LocationDataProviderError>, CLLocationManagerDelegate {
    static let shared: LocationDataProvider = .init()
        
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    override func start() {
        if checkAuthorization() {
            locationManager.startUpdatingLocation()
        } else {
            fail(with: LocationDataProviderError.authorizedDenied)
        }
    }
    
    override func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            send(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        fail(with: LocationDataProviderError.locationManagerError(error: error))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
    
    @discardableResult
    private func checkAuthorization() -> Bool {
        return [.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus)
    }
    
}
