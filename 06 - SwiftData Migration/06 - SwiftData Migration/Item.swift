//
//  Item.swift
//  06 - SwiftData Migration
//
//  Created by Andrei Maksimovich on 20/04/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
