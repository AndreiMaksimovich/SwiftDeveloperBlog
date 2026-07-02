//
//  MapAssets.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich
//

import Foundation

class MapAssets {
    
    private static var bundleUrl: URL = {
        Bundle.main.bundleURL.appending(path: "Assets/MapAssets")
    }()
    
    static var pathFonts: String = {
        bundleUrl.appending(path: "fonts").absoluteString
    }()
    
    static func pathSprites(mapStyle: MapStyle, subfolder: String? = nil) -> String {
        bundleUrl.appending(path: "\(mapStyle.rawValue)/sprites/\(subfolder != nil ? "\(subfolder!)/" : "")sprites").absoluteString
    }
    
    static func pathPath(_ id: String) -> String? {
        Bundle.main.path(forResource: id, ofType: "geojson", inDirectory: "Assets/MapData/paths")
    }
    
    static func pathMap(_ id: String) -> String {
        let bundlePath = Bundle.main.path(forResource: id, ofType: "mbtiles", inDirectory: "Assets/MapData")!
        return "mbtiles://\(bundlePath)"
    }
    
}
