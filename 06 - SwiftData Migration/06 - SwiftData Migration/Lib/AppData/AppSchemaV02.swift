//
//  AppSchemaV02.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich
//

import SwiftData
import Foundation

enum AppDataSchemaV02: VersionedSchema {
    static let models: [any PersistentModel.Type] = [Path.self, PathPoint.self]
    static let versionIdentifier = Schema.Version(0, 2, 0)
    
    @Model
    class Path {
        #Index([\Path.uid])
        #Unique([\Path.uid])
        
        var uid: UUID
        var title: String
        var comment: String = ""
        @Relationship(deleteRule: .cascade, inverse: \PathPoint.path) var points = [PathPoint]()
        
        init(uid: UUID = .init(), title: String, commnent: String, points: [PathPoint]) {
            self.uid = uid
            self.title = title
            self.comment = commnent
            self.points = points
        }
    }
    
    @Model
    class PathPoint {
        var path: Path
        var lattitude: Double
        var longitude: Double
        var altitude: Double = 0
        var time: Date
        
        init(path: Path, lattitude: Double, longitude: Double, altitude: Double, time: Date = .now) {
            self.path = path
            self.lattitude = lattitude
            self.longitude = longitude
            self.altitude = altitude
            self.time = time
        }
    }
}
