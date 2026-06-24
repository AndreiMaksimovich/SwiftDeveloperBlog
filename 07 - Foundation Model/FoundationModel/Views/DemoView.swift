//
//  DemoView.swift
//  SwiftDeveloperBlog

import SwiftUI
import Speech

struct DemoView: View {
    
    @State private var date1: Date = .now
    @State private var date2: Date = .now
    
    @Environment(LMManager.self) private var lmManager
    @Environment(SpeechRecognitionManager.self) private var srManager
        
    var body: some View {
        VStack {
            
            DatePickerWithVoiceInput(date: $date1)
            DatePickerWithVoiceInput(date: $date2)
            
            if !lmManager.isAvailable {
                Text("LM Model is not available")
                    .foregroundStyle(.red)
            }
            
            if !srManager.isAvaiable {
                Text("Speech recognition is not available")
                    .foregroundStyle(.red)
            }
        }
    }
    
}


#Preview {
    PreviewConatiner {
        DemoView()
    }
}
