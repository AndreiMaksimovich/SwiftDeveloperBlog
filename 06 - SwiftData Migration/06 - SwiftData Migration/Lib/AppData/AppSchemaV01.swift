//
//  AppSchemaV01.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich
//

import SwiftData
import Foundation


enum AppDataSchemaV01: VersionedSchema {
    static let models: [any PersistentModel.Type] = [Path.self, PathPoint.self]
    static let versionIdentifier = Schema.Version(0, 1, 0)
    
    @Model
    class Path {
        #Index([\Path.uid])
        #Unique([\Path.uid])
        
        var uid: UUID
        var title: String
        @Relationship(deleteRule: .cascade) var points: [PathPoint]
        
        init(uid: UUID = .init(), title: String, points: [PathPoint]) {
            self.uid = uid
            self.title = title
            self.points = points
        }
    }
    
    @Model
    class PathPoint {
        var lattitude: Double
        var longitude: Double
        var time: Date
        
        init(lattitude: Double, longitude: Double, time: Date = .now) {
            self.lattitude = lattitude
            self.longitude = longitude
            self.time = time
        }
    }
}
