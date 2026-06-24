//
//  SpeechRecognitionButton.swift
//  SwiftDeveloperBlog

import SwiftUI

struct SpeechRecognitionButton: View {
    private static let logTag = "[SpeechRecognitionButton]"
    
    @State private var isPressed: Bool = false
    @State private var isRecording: Bool = false
    
    let reportPartialResults: Bool
    let handler: SpeechRecognitionHandler
    
    init(reportPartialResults: Bool = false, handler: @escaping SpeechRecognitionHandler) {
        self.reportPartialResults = reportPartialResults
        self.handler = handler
    }
    
    var body: some View {
        Button {} label: {
            Image(systemName: "microphone")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
            .buttonStyle(SpeechRecognitionButtonStyle(onIsPressedChanged: onIsPressedChanged))
            .sensoryFeedback(trigger: isRecording) {oldValue, newValue in
                newValue ? .start : .stop
            }
    }
        
    private func onIsPressedChanged(_ isPressed: Bool) {
        guard isPressed != self.isPressed else {
            return
        }
        
        Task {@MainActor in
            self.isPressed = isPressed
            print(isPressed)
            if isPressed {
                do {
                    try await SpeechRecognitionManager.shared.start(handler: self.handler)
                    self.isRecording = true
                } catch {
                    print(Self.logTag, "SpeechRecognitionManager.shared.start failed", error)
                }
            } else {
                if self.isRecording {
                    self.isRecording = false
                    SpeechRecognitionManager.shared.stop()
                }
            }
        }
    }
    
    struct SpeechRecognitionButtonStyle: ButtonStyle {
        let onIsPressedChanged: (Bool) -> Void
        
        func makeBody(configuration: Configuration) -> some View {
                onIsPressedChanged(configuration.isPressed)
                return configuration.label
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.5), lineWidth: 0.4)
                            .blendMode(.overlay)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .scaleEffect(configuration.isPressed ? 1.2 : 1)
                    .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}

#Preview {
    SpeechRecognitionButton(reportPartialResults: true, handler: {result, error, isFinal in})
}
