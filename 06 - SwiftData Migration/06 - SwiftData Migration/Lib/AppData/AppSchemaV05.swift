//
//  AppSchemaV02.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich
//

import SwiftData
import Foundation

enum AppDataSchemaV05: VersionedSchema {
    static let models: [any PersistentModel.Type] = [Path.self, PathPoint.self]
    static let versionIdentifier = Schema.Version(0, 5, 0)
    
    @Model
    class Path {
        #Index([\Path.uid])
        #Unique([\Path.uid])
        
        var uid: UUID
        var title: String
        var comment: String = ""
        @Relationship(deleteRule: .cascade, inverse: \PathPoint.path) var points = [PathPoint]()
        var duration: TimeInterval?
        var someRandomAdditionalField: String?
        
        init(uid: UUID = .init(), title: String, commnent: String, duration: TimeInterval?, points: [PathPoint]) {
            self.uid = uid
            self.title = title
            self.comment = commnent
            self.points = points
            self.duration = duration
        }
    }
    
    @Model
    class PathPoint {
        #Index([\PathPoint.path], [\PathPoint.cell100], [\PathPoint.cell1000])
        
        var path: Path
        var lattitude: Double
        var longitude: Double
        var altitude: Double = 0
        var time: Date
        var cell100: Int64?
        var cell1000: Int64?
        
        init(path: Path, lattitude: Double, longitude: Double, altitude: Double, cell100: Int64, cell1000: Int64, time: Date = .now) {
            self.path = path
            self.lattitude = lattitude
            self.longitude = longitude
            self.altitude = altitude
            self.time = time
            self.cell100 = cell100
            self.cell1000 = cell1000
        }
    }
}
