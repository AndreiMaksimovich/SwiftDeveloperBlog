//
//  SpeechRecognitionManager.Types.swift
//  SwiftDeveloperBlog

public extension SpeechRecognitionManager {
    enum RecognizerState {
        case notAvailable
        case notAuthorized
        case idle
        case recording
    }
    
    enum RecognizerError: Error {
        case notAvailable
        case notAuthorized
        case recognizerIsUnavailable
        case otherRecognitionInProgress
        
        public var message: String {
            switch self {
                case .notAvailable: "Can't initialize speech recognizer"
                case .notAuthorized: "Not authorized to recognize speech or/and recrod audio"
                case .recognizerIsUnavailable: "Recognizer is unavailable"
                case .otherRecognitionInProgress: "Other recognition in progress"
            }
        }
    }
}
