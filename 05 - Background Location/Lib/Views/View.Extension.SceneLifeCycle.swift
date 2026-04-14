//
//  View.Extension.SceneLifeCYcle.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 15/04/2026.
//

import SwiftUI

public struct ActionOnNotificationCenterEventViewModifier: ViewModifier {
    private let action: () -> Void
    private let notificationName: Notification.Name
    public init(notificationName: Notification.Name, action: @escaping () -> Void) {
        self.action = action
        self.notificationName = notificationName
    }
    public func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: notificationName)) {_ in
                action()
            }
    }
}

public extension View {
    func onWillEnterForeground(action: @escaping () -> Void) -> some View {
        modifier(ActionOnNotificationCenterEventViewModifier(notificationName: UIScene.willEnterForegroundNotification, action: action))
    }
    
    func onDidEnterBackground(action: @escaping () -> Void) -> some View {
        modifier(ActionOnNotificationCenterEventViewModifier(notificationName: UIScene.didEnterBackgroundNotification, action: action))
    }
    
    func onWillTerminate(action: @escaping () -> Void) -> some View {
        modifier(ActionOnNotificationCenterEventViewModifier(notificationName: UIApplication.willTerminateNotification, action: action))
    }
}
