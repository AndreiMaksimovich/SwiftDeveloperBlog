//
//  Utils.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 24/04/2026.
//

import Foundation

extension FileManager {
    
    func removeFiles(_ files: URL...) throws {
        try removeFiles(files)
    }
    
    func removeFiles(_ files: [URL]) throws {
        try files.forEach {fileUrl in
            let filePath = fileUrl.path()
            if FileManager.default.fileExists(atPath: filePath) {
                try FileManager.default.removeItem(atPath: filePath)
            }
        }
    }
}
