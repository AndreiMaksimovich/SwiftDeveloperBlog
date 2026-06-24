//
//  DatePickerWithVoiceInput.swift
//  SwiftDeveloperBlog

import SwiftUI
import Speech

struct DatePickerWithVoiceInput: View {
    
    @Binding var date: Date
    
    @Environment(LMManager.self) private var lmManager
    @Environment(SpeechRecognitionManager.self) private var srManager
    
    var body: some View {
        HStack {
            DatePicker("", selection: $date, displayedComponents: [.date])
                .labelsHidden()
            
            if lmManager.isAvailable && srManager.isAvaiable {
                SpeechRecognitionButton {result, error, isFinal in
                    Task {
                        guard isFinal, let userInput = result?.bestTranscription.formattedString, !userInput.isEmpty else {
                            return
                        }
                        
                        debugPrint("User input: \(userInput)")
                        
                        guard let date = try await lmManager.extractDateFromUserInput(userInput: userInput) else {
                            return
                        }
                        
                        debugPrint("Date: \(date)")
                        
                        self.date = date
                    }
                }
            }
        }
    }
}
