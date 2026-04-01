//
//  TestView.Types.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 02/04/2026.
//

import Foundation

protocol ITestViewModel: Observable, AnyObject {
    var accelerometerData: AccelerometerData? {get}
    var error: Error? {get}
    
    func onButtonTap_doSomeStuff()
    func onAppear()
    func onDisappear()
}
