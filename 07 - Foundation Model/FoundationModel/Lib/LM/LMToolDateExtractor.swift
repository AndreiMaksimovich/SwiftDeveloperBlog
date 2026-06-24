//
//  LMToolDateExtractor.swift
//  SwiftDeveloperBlog
//

import Foundation
import FoundationModels

struct LMToolDateExtractor: Tool {
    let name: String = "LMToolDateExtractor"
    let description: String = "Extracts date from user query"
    
    @Generable
    struct Arguments {
        @Guide(description: "Numeric year extracted from the date mentioned in the user's input (for example, 2025).")
        var year: Int?
        
        @Guide(description: "Numeric month extracted from the date mentioned in the user's input, where January = 1 and December = 12.")
        var month: Int?
        
        @Guide(description: "Numeric day of the month extracted from the date mentioned in the user's input, from 1 to 31.")
        var day: Int?
        
        init(year: Int? = nil, month: Int? = nil, day: Int? = nil) {
            self.year = year
            self.month = month
            self.day = day
        }
        
        init(_ year: Int, _ month: Int, _ day: Int) {
            self.year = year
            self.month = month
            self.day = day
        }
    }
    
    func call(arguments: Arguments) async throws -> Arguments {
        let nowComponents = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        
        var year = arguments.year ?? nowComponents.year!
        var month = arguments.month ?? nowComponents.month!
        var day = arguments.day ?? nowComponents.day!
        
        if year <= 0 {
            year = nowComponents.year!
        }
        
        if month < 1 || month > 12 {
            month = nowComponents.month!
        }
        
        if day < 1 || day > 31 {
            day = nowComponents.day!
        }
                
        return .init(year: year, month: month, day: day)
    }
}
