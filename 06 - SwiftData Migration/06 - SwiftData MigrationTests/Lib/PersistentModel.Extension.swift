//
//  PersistentModel.Extension.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 24/04/2026.
//

import SwiftData
import Foundation

public extension PersistentModel {
    static var typeId: ObjectIdentifier {
        ObjectIdentifier(self)
    }
}
