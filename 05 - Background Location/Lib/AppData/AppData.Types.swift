//
//  PathRecord.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 13/04/2026.
//

import Foundation
import SwiftData
import CoreLocation


struct PathTmpPoint {
    var latitude: Double
    var longitude: Double
    var altitude: Double
    var time: TimeInterval
    
    init(latitude: Double, longitude: Double, altitude: Double = 0, time: TimeInterval = Date.now.timeIntervalSince1970) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.time = time
    }
    
    static func from(location: CLLocation) -> PathTmpPoint {
        .init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, altitude: location.altitude)
    }
}

typealias PathRecord = AppDataSchemaV1.PathRecord
typealias PathRecordPoint = AppDataSchemaV1.PathRecordPoint

enum AppDataSchemaV1: VersionedSchema {
    
    static let models: [any PersistentModel.Type] = [AppDataSchemaV1.PathRecord.self, AppDataSchemaV1.PathRecordPoint.self]
    static let versionIdentifier = Schema.Version(1, 0, 0)
    
    @Model
    class PathRecord {
        var title: String
        var text: String
        @Relationship(deleteRule: .cascade) var points = [PathRecordPoint]()

        init(title: String = "", text: String = "", points: [PathRecordPoint] = []) {
            self.title = title
            self.text = text
            self.points = points
        }
    }

    @Model
    class PathRecordPoint {
        var latitude: Double
        var longitude: Double
        var altitude: Double
        var time: TimeInterval
        
        init(latitude: Double, longitude: Double, altitude: Double = 0, time: TimeInterval = Date.now.timeIntervalSince1970) {
            self.latitude = latitude
            self.longitude = longitude
            self.altitude = altitude
            self.time = time
        }
        
        static func from(location: CLLocation) -> PathRecordPoint {
            .init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, altitude: location.altitude)
        }
        
        static func from(tmpPoint: PathTmpPoint) -> PathRecordPoint {
            .init(latitude: tmpPoint.latitude, longitude: tmpPoint.longitude, altitude: tmpPoint.altitude, time: tmpPoint.time)
        }
    }
    
}
