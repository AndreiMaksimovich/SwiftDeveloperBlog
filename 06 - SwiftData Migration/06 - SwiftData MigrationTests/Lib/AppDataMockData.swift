//
//  MockData.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 21/04/2026.
//

import SwiftData
import Foundation
@testable import _6___SwiftData_Migration


nonisolated var appDataMockDataSetV01: AppDataMockDataSet {
    [
        AppDataSchemaV01.Path.typeId : [
            AppDataSchemaV01.Path(
                uid: .init(uuidString: "b02f278b-27ba-455c-a0c2-923217d23687")!,
                title: "Path Title",
                points: [
                    .init(lattitude: 41.65105802876141, longitude: 41.64347309309252, time: .init(timeIntervalSince1970: Double(1776765677))), // Tue, 21 Apr 2026 10:01:17 GMT
                    .init(lattitude: 41.65325936997036, longitude: 41.63928245352322, time: .init(timeIntervalSince1970: Double(1776766197))), // Tue, 21 Apr 2026 10:09:57 GMT
                    .init(lattitude: 41.65027995050913, longitude: 41.62996145517464, time: .init(timeIntervalSince1970: Double(1776766797))), // Tue, 21 Apr 2026 10:19:57 GMT
                ])
        ]
    ]
}

nonisolated var appDataMockDataSetV03: AppDataMockDataSet{
    let path = AppDataSchemaV03.Path(
        uid: .init(uuidString: "b02f278b-27ba-455c-a0c2-923217d23687")!,
        title: "Path Title",
        commnent: "",
        duration: 123,
        points: [],
    )
    
    path.points = [
        .init(path: path, lattitude: 41.65105802876141, longitude: 41.64347309309252, altitude: 0, cell100: 100, cell1000: 1000, time: .init(timeIntervalSince1970: Double(1776765677))), // Tue, 21 Apr 2026 10:01:17 GMT
        .init(path: path, lattitude: 41.65325936997036, longitude: 41.63928245352322, altitude: 0, cell100: 100, cell1000: 1000, time: .init(timeIntervalSince1970: Double(1776766197))), // Tue, 21 Apr 2026 10:09:57 GMT
        .init(path: path, lattitude: 41.65027995050913, longitude: 41.62996145517464, altitude: 0, cell100: 100, cell1000: 1000, time: .init(timeIntervalSince1970: Double(1776766797))), // Tue, 21 Apr 2026 10:19:57 GMT
    ]
    
    return [AppDataSchemaV03.Path.typeId : [path]]
}
