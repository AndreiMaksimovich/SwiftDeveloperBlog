//
//  PathEditViewModel.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 16/04/2026.
//

import SwiftUI
import CoreLocation
import Combine

enum PathEditViewModelPathRecorderState {
    case notInitialized
    case locationAuthorizationInProgress
    case notAuthorized
    case active
    case innactive
    case failed
}

protocol IPathEditViewModel: AnyObject, Observable {
    var mode: PathEditView.Mode {get}
    
    var pathRecorderState: PathEditViewModelPathRecorderState {get}
    var pathRecorderError: Error? {get}
    
    func insertPathRecord()
    
    func onAppear()
    func onDisappear()
    
    func startPathRecording()
    func stopPathRecording()
    
    func onWillEnterForeground()
    func onDidEnterBackground()
}

@Observable
class PathEditViewModel: IPathEditViewModel {
    private let logTag = "PathEditViewModel"
    let mode: PathEditView.Mode
    
    private let pathRecord: PathRecord
    private let locationAuthorizationManager: any ILocationAuthorizationManager
    private let backgroundLocationDataProvider: any IBackgroundLocationDataProvider
    private let pathRecordManager: any IPathRecordManager
    
    private(set) var pathRecorderState: PathEditViewModelPathRecorderState = .notInitialized
    private(set) var pathRecorderError: Error?

    
    private var cancellables: [AnyCancellable] = []
    private var backgroundLocationDataProviderSubscription: AnyCancellable?
    
    private var isRunningInBackground: Bool = false
    
    init(pathRecord: PathRecord, mode: PathEditView.Mode) {
        self.pathRecord = pathRecord
        self.mode = mode
        self.locationAuthorizationManager = AppEnvironment.shared.locationAuthorizationManager
        self.backgroundLocationDataProvider = AppEnvironment.shared.backgroundLocationDataProvider
        self.pathRecordManager = AppEnvironment.shared.pathRecordManager
    }
    
    init(
        pathRecord: PathRecord, mode: PathEditView.Mode,
        locationAuthorizationManager: any ILocationAuthorizationManager,
        backgroundLocationDataProvider: any IBackgroundLocationDataProvider,
        pathRecordManager: any IPathRecordManager
    ) {
        self.pathRecord = pathRecord
        self.mode = mode
        self.locationAuthorizationManager = locationAuthorizationManager
        self.backgroundLocationDataProvider = backgroundLocationDataProvider
        self.pathRecordManager = pathRecordManager
    }
    
    private func checkAuthorizationStatus() {
        switch locationAuthorizationManager.authorizationStatus {
            case .notDetermined:
                pathRecorderState = .locationAuthorizationInProgress
                locationAuthorizationManager.requestAlwaysAuthorization()
                break
            case .authorizedAlways, .authorizedWhenInUse:
                if ![.active, .failed].contains(pathRecorderState)  {
                    pathRecorderState = .innactive
                }
                break
            default:
                backgroundLocationDataProviderSubscription?.cancel()
                pathRecorderState = .notAuthorized
                break
        }
    }
    
    private var recordInserted: Bool = false
    func insertPathRecord() {
        guard mode == .add, !recordInserted else  {
            return
        }
        
        recordInserted = true
        pathRecordManager.insert(record: pathRecord)
    }
    
    func onAppear() {
        cancellables.append(
            locationAuthorizationManager.authorizationStatusPublisher.sink {_ in
                self.checkAuthorizationStatus()
            }
        )
        checkAuthorizationStatus()
    }
    
    func startPathRecording() {
        guard [.failed, .innactive].contains(pathRecorderState) else {
            return
        }
        
        backgroundLocationDataProviderSubscription = backgroundLocationDataProvider.backgroundLocationPublisher.sink(
            receiveCompletion: {completion in
                guard self.pathRecorderState != .notAuthorized else {
                    return
                }
                if case .failure(let error) = completion {
                    self.pathRecorderState = .failed
                    self.pathRecorderError = error
                } else {
                    self.pathRecorderState = .innactive
                }
            },
            receiveValue: {location in
                self.processLocationUpdate(location)
            }
        )
        
        pathRecorderState = .active
    }
    
    private var backgroundLocationUpdatesAccumulator: [PathTmpPoint] = []
    
    private func processLocationUpdate(_ location: CLLocation) {
        print(logTag, "processLocationUpdate isRunningInBackground=\(isRunningInBackground)")
        if isRunningInBackground {
            backgroundLocationUpdatesAccumulator.append(.from(location: location))
        } else {
            withAnimation {
                pathRecord.points.append(.from(location: location))
            }
        }
    }
    
    func stopPathRecording() {
        guard pathRecorderState == .active else {
            return
        }
        
        pathRecorderState = .innactive
        backgroundLocationDataProviderSubscription?.cancel()
    }
    
    func onDisappear() {
        cancellables.forEach {
            $0.cancel()
        }
        cancellables.removeAll()
        backgroundLocationDataProviderSubscription?.cancel()
        pathRecorderState = .notInitialized
    }
    
    func onWillEnterForeground() {
        isRunningInBackground = false
        checkAuthorizationStatus()
        if !backgroundLocationUpdatesAccumulator.isEmpty {
            pathRecord.points.append(contentsOf: backgroundLocationUpdatesAccumulator.map { PathRecordPoint.from(tmpPoint: $0) } )
            backgroundLocationUpdatesAccumulator.removeAll()
        }
    }
    
    func onDidEnterBackground() {
        isRunningInBackground = true
    }
}
