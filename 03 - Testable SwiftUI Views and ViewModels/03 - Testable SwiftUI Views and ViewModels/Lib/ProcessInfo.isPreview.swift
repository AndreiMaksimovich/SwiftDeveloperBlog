//
//  ProcessInfo.isPreview.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 06/04/2026.
//

import Foundation

extension ProcessInfo {
    static var isPreview: Bool {
        processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
