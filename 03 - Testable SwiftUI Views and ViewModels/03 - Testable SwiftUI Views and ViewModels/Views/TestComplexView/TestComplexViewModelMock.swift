//
//  TestComplexViewModelMock.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 06/04/2026.
//

import SwiftUI

@Observable
class TestComplexViewModelMock: ITestComplexViewModel {
    var someValue: String = "Hello World Mock"
    
    func setSomeValue(_ value: String) {
        someValue = value
    }
}
