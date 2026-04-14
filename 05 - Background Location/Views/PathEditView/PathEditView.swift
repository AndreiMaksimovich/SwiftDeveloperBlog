//
//  PathRecordingView.swift
//  05 - Background Location
//
//  Created by Andrei Maksimovich on 14/04/2026.
//

import SwiftUI
import CoreLocation
import Combine

struct PathEditView: View {
    
    private let logTag = "PathEditView"
    @State var model: any IPathEditViewModel
    @State var pathRecord: PathRecord
    
    init(mode: Mode, pathRecord: PathRecord = .init()) {
        self.pathRecord = pathRecord
        self.model = PathEditViewModel(pathRecord: pathRecord, mode: mode)
    }
    
    init(mode: Mode, pathRecord: PathRecord = .init(), model: any IPathEditViewModel) {
        self.pathRecord = pathRecord
        self.model = model
    }
    
    @ViewBuilder private var locationAuthorizarionErrorView: some View {
        Text("To ensure reliable background execution, please change location access to 'Always' in the system settings.")
        Button("Open Settings") {
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        }
    }
    
    var body: some View {
        print("Redraw")
        return VStack {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text("Title").font(.default.bold())
                        TextEditor(text: $pathRecord.title)
                            .padding(5)
                            .frame(minHeight: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.secondary, lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Description").font(.default.bold())
                        TextEditor(text: $pathRecord.text)
                            .multilineTextAlignment(.leading)
                            .padding(5)
                            .frame(minHeight: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.secondary, lineWidth: 1)
                            )
                    }
                }
                
                Section("Record path") {
                    VStack {
                        if let error = model.pathRecorderError {
                            Text(error.localizedDescription).foregroundStyle(Color.red)
                        }
                        HStack {
                            switch model.pathRecorderState {
                                case .notInitialized, .locationAuthorizationInProgress:
                                    ProgressView().progressViewStyle(.circular)
                                case .notAuthorized:
                                    locationAuthorizarionErrorView
                                case .active:
                                    Button("Stop") {
                                        model.stopPathRecording()
                                    }
                                case .innactive:
                                    Button("Start") {
                                        model.startPathRecording()
                                    }
                                case .failed:
                                    Button("Retry") {
                                        model.startPathRecording()
                                    }
                            }
                            
                            Spacer()
                            
                            Button("Clear") {
                                pathRecord.points.removeAll()
                            }
                        }
                        .buttonStyle(.glassProminent)
                    }
                    List {
                        ForEach(pathRecord.points) {pathPoint in
                            PathPointView(pathPoint: pathPoint)
                        }
                        .onDelete {indexes in
                            pathRecord.points.remove(atOffsets: indexes)
                        }
                    }
                }
            }
            
            if model.mode == .add {
                Button("Save") {
                    model.insertPathRecord()
                    AppNavigator.shared.back()
                }
            }
        }
        .onAppear {
            print(logTag, "onAppear")
            model.onAppear()
        }
        .onDisappear {
            print(logTag, "onDisappear")
            model.onDisappear()
        }
        .onWillEnterForeground {
            print(logTag, "onWillEnterForeground")
            model.onWillEnterForeground()
        }
        .onDidEnterBackground {
            print(logTag, "onDidEnterBackground")
            model.onDidEnterBackground()
        }
    }
    
    enum Mode {
        case add
        case edit
    }
}

#Preview {
    PreviewConatiner {
        PathEditView(mode: .add)
    }
}
