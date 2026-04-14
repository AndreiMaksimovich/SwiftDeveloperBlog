//
//  CLAuthorizationStatus.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 16/04/2026.
//

import CoreLocation

public extension CLAuthorizationStatus {
    
    var description: String {
        switch self {
            case .authorizedAlways: "Authorized Always"
            case .authorizedWhenInUse: "Authorized When In Use"
            case .denied: "Denied"
            case .notDetermined: "Not Determined"
            case .restricted: "Restricted"
            default: "Unknown"
        }
    }
}

