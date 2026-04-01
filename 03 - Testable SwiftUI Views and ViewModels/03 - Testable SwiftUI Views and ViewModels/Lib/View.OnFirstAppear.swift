//
//  View.OnFirstAppear.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 02/04/2026.
//

import SwiftUI

public extension View {
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(ViewModifierOnFirstAppear(action: action))
    }
}

struct ViewModifierOnFirstAppear: ViewModifier {
    @State private var hasAppeared = false
    let action: () -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            if !hasAppeared {
                hasAppeared = true
                action()
            }
        }
    }
}
