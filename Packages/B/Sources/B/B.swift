// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

public extension Bundle {
    
    static let b = Bundle.module
    
}

public extension LocalizedStringResource {
    
    static let b_helloWorld = LocalizedStringResource("HelloWorld", bundle: .b)
    
}
