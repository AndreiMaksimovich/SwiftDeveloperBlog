//
//  SpeechRecognitionManager.Authorization.swift
//  SwiftDeveloperBlog

import AVFoundation
import Speech

extension SpeechRecognitionManager {
    
    func requestPermissions() async -> Bool {
        guard await hasPermissionToRecord(), await hasAuthorizationToRecognize() else {
            state = .notAuthorized
            return false
        }
        
        return true
    }
    
    private func hasPermissionToRecord() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { authorized in
                continuation.resume(returning: authorized)
            }
        }
    }
    
    func hasAuthorizationToRecognize() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
}
