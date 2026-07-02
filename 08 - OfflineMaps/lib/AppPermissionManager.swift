//
//  AppPermissionManager.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich
//

import CoreLocation

@MainActor
@Observable
class AppPermissionManager: NSObject, @MainActor CLLocationManagerDelegate {
    private static let logTag: String = "[AppPermissionManager]"
    static let shared: AppPermissionManager = .init()
    
    var locationPermission: CLAuthorizationStatus
    
    private let locationManager: CLLocationManager = .init()
    
    private override init() {
        locationPermission = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        initialize()
    }
    
    func initialize() {
        guard locationPermission == .notDetermined else {
            return
        }
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationPermission = status
    }
    
}
