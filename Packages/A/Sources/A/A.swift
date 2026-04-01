// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

public extension Bundle {
    
    static let a = Bundle.module
    
}

public extension LocalizedStringResource {
    
    enum Public {
        
        public static let helloWorld: LocalizedStringResource = .helloWorld
        
    }
    
}
