//
//  AppNavigationDestination.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 14/04/2026.
//

import Foundation
import SwiftUI

enum AppNavigationDestination: Hashable {
    case pathDetail(pathRecord: PathRecord)
    case editPath(pathRecord: PathRecord)
    case recordNewPath
    case pathList
}

@Observable
class AppNavigator {
    static let shared = AppNavigator()
    
    var path: NavigationPath = .init()
    
    func open(destination: AppNavigationDestination) {
        path.append(destination)
    }
    
    func back() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func toMainMenu() {
        guard !path.isEmpty else { return }
        path.removeLast(path.count)
    }
}

@ViewBuilder func getAppNavigationDestination(for destination: AppNavigationDestination) -> some View {
    switch destination {
        case .pathDetail(pathRecord: let pathRecord):
            PathDetailView(pathRecord: pathRecord)
        case .recordNewPath:
            PathEditView(mode: .add)
        case .pathList:
            PathListView()
        case .editPath(pathRecord: let pathRecord):
            PathEditView(mode: .edit, pathRecord: pathRecord)
    }
}
