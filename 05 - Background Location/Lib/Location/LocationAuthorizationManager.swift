//
//  LocationAuthorizationManager.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 14/04/2026.
//

import Foundation
import CoreLocation
import Combine

@MainActor
public protocol ILocationAuthorizationManager: Observable {
    var authorizationStatus: CLAuthorizationStatus { get }
    var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> { get }
    func requestAlwaysAuthorization()
    func requestWhenInUseAuthorization()
}

@Observable
public class LocationAuthorizationManager: NSObject, ILocationAuthorizationManager, CLLocationManagerDelegate {
    private let logTag = "LocationAuthorizationManager"
    
    private let authorizationStatusPublisherPassthrough: PassthroughSubject<CLAuthorizationStatus, Never> = .init()
    private let locationManager: CLLocationManager
    public private(set) var authorizationStatus: CLAuthorizationStatus {
        didSet {
            authorizationStatusPublisherPassthrough.send(authorizationStatus)
        }
    }
    
    public var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationStatusPublisherPassthrough.eraseToAnyPublisher()
    }
    
    public func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = locationManager.authorizationStatus
    }
    
    override init() {
        let locationManager = CLLocationManager()
        self.locationManager = locationManager
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
    }
}
