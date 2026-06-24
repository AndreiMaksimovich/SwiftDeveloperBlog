//
//  SpeechRecognitionManager.swift
//  SwiftDeveloperBlog
//

import AVFoundation
import Speech

public typealias SpeechRecognitionHandler = (SFSpeechRecognitionResult?, Error?, Bool) -> Void

@Observable
public class SpeechRecognitionManager {
    
    private static let logTag = "[SpeechRecognitionManager]"
    
    public static let shared = SpeechRecognitionManager()
    
    public var state: RecognizerState = .idle
            
    private var audioEngine: AVAudioEngine? = nil
    private var request: SFSpeechAudioBufferRecognitionRequest? = nil
    private var task: SFSpeechRecognitionTask? = nil
    private var recognizer: SFSpeechRecognizer? = nil
    
    public var isAvaiable: Bool {
        switch state {
            case .idle, .recording: true
            default: false
        }
    }
    
    public var isRecording: Bool { state == .recording }
    
    private init() {
        recognizer = SFSpeechRecognizer()
    
        guard let recognizer, recognizer.isAvailable else {
            state = .notAvailable
            return
        }
    }
    
    public func configure(locale: Locale) -> Bool {
        recognizer = SFSpeechRecognizer(locale: locale)
        
        guard let recognizer, recognizer.isAvailable else {
            state = .notAvailable
            return false
        }
        
        return true
    }
    
    public func start(shouldReportPartialResults: Bool = true, handler: @escaping SpeechRecognitionHandler) async throws {
        guard let recognizer, isAvaiable else {
            throw RecognizerError.notAvailable
        }
        
        guard await requestPermissions() else {
            throw RecognizerError.notAuthorized
        }
        
        if state == .recording {
            throw RecognizerError.otherRecognitionInProgress
        }
        
        do {
            let (audioEngine, request) = try prepareAudioEngineForSpeechRecognition()
            self.audioEngine = audioEngine
            self.request = request
            let task = recognizer.recognitionTask(with: request, resultHandler: { [weak self] result, error in
                let isFinal = (result?.isFinal ?? false) || (error != nil)
                
                if isFinal {
                    self?.reset()
                }
                
                handler(result, error, isFinal)
            })
            self.task = task
            state = .recording
        } catch {
            throw error
        }
    }
    
    public func stop() {
        guard state == .recording else { return }
        request?.endAudio()
    }
    
    private func reset() {
        task?.cancel()
        if let audioEngine {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        audioEngine = nil
        request = nil
        task = nil
        
        if state == .recording {
            state = .idle
        }
    }
    
    private func prepareAudioEngineForSpeechRecognition(shouldReportPartialResults: Bool = true) throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = shouldReportPartialResults
        
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            request.append(buffer)
        }
    
        audioEngine.prepare()
        try audioEngine.start()
        
        return (audioEngine, request)
    }
}
