//
//  AppDataSchema.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 14/04/2026.
//

import SwiftData

let appDataSchema = Schema(versionedSchema: AppDataSchemaV1.self)

func instantiateAppDataModelContainer(isStoredInMemoryOnly: Bool = false) -> ModelContainer {
    let modelConfiguration = ModelConfiguration(schema: appDataSchema, isStoredInMemoryOnly: isStoredInMemoryOnly)
    return try! ModelContainer(for: appDataSchema, configurations: [modelConfiguration])
}
