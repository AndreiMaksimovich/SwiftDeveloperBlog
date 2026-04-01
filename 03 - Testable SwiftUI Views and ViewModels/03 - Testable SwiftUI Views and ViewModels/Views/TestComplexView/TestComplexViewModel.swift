//
//  TestComplexViewModel.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 06/04/2026.
//

import SwiftUI

protocol ITestComplexViewModel: Observable, AnyObject {
    var someValue: String { get }
    func setSomeValue(_ value: String)
}

@Observable
class TestComplexViewModel: ITestComplexViewModel {
    var someValue: String = "Hello World"
    
    func setSomeValue(_ value: String) {
        someValue = value
    }
}
