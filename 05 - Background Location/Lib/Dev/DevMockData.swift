//
//  DevMockData.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 14/04/2026.
//

#if DEBUG

import SwiftData
import Foundation

let pathRecordPreviewMockData: PathRecord = .init(title: "Path 1", text: "Path 1 description", points: [
    .init(latitude: 41.65109136174593, longitude: 41.64342868059114, altitude: 5, time: 1776156600),
    .init(latitude: 41.64959649137868, longitude: 41.64444419904289, altitude: 10, time: 1776156700),
])

func insertMockData(modelContext: ModelContext) {
    let data: [PathRecord] = [
        pathRecordPreviewMockData,
        .init(title: "Path 2", text: "Path 2 description", points: [
            .init(latitude: 41.65109136174593, longitude: 41.64342868059114, altitude: 5, time: 1776156600),
            .init(latitude: 41.64959649137868, longitude: 41.64444419904289, altitude: 10, time: 1776156700),
        ])
    ]
    
    
    data.forEach {pathRecord in
        modelContext.insert(pathRecord)
    }
}

#endif
