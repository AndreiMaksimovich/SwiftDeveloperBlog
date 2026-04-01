//
//  LocationDataProviderTestView.swift
//  02 - DynamicPublisher
//
//  Created by Andrei Maksimovich on 29/03/2026.
//

import SwiftUI
import MapKit
import Combine
import UIKit

struct LocationDataProviderTestView: View {
    @State var model = LocationDataProviderTestViewModel()
    
    var body: some View {
        VStack {
            
            VStack (alignment: .leading) {
                
                // Location
                if let location = model.location {
                    Text("**Location:**:")
                    Text("  lat:  \(location.coordinate.latitude)")
                    Text("  long: \(location.coordinate.longitude)")
                } else {
                    Text("**Location:** NIL")
                }
                
                // State
                Text(LocalizedStringKey("**State:**: \(hrState)"))
                
                // Authorization status
                Text("**Authorization status:** \(hrAuthorizationStatus)")
                
                // Error
                if let error = model.error {
                    Text(String(stringLiteral: "Error: \(error)"))
                        .foregroundStyle(.red)
                }
                
            }
            
            // Authorization button
            if showAuthorizeButton {
                Button("Authorize") {
                    model.onButtonClick_requestAuthorization()
                }
            }
                        
            // Subscribe button
            if showSubscribeButton {
                Button("Subscribe") {
                    model.onButtonClick_subscribe()
                }
            }
            
            // Unsubscribe button
            if showUnsubscribeButton {
                Button("Unsubscribe") {
                    model.onButtonClick_unsubscribe()
                }
            }
            
            // Settings button
            Button("Settings") {
                model.onButtonClick_openSystemAppSettings()
            }
            
            Spacer()
            
            // Inner view
            NavigationLink(destination: Text("Second Screen"), label: {Text("Open Second Screen")})
        }
        .onAppear {
            model.onAppear()
        }
        .onDisappear {
            model.onDisappear()
        }
    }
    
    // Human readable localization authorization status
    private var hrAuthorizationStatus: String {
        switch model.locationAuthorizationStatus {
            case .notDetermined: "Not determined"
            case .restricted: "Restrcted"
            case .denied: "Denied"
            case .authorizedAlways: "Authorized always"
            case .authorizedWhenInUse: "Authrized when in use"
            case .authorized: "Authorized"
            default: "Unknown"
        }
    }
    
    // Human readable state
    private var hrState: String {
        switch model.state {
            case .failed: "Failed"
            case .notSubscribed: "Not subscribed"
            case .subscribed: "Subscribed"
        }
    }
    
    private var showSubscribeButton: Bool {
        model.state != .subscribed
    }
    
    private var showUnsubscribeButton: Bool {
        model.state == .subscribed
    }
    
    private var showAuthorizeButton: Bool {
        [.notDetermined].contains(model.locationAuthorizationStatus)
    }
       
}

enum LocationDataProviderTestViewState {
    case notSubscribed
    case subscribed
    case failed
}

@Observable
class LocationDataProviderTestViewModel: NSObject, CLLocationManagerDelegate {
    private let logTag = "TestViewModel"
    
    private(set) var state = LocationDataProviderTestViewState.notSubscribed {
        didSet {
            if state != .failed {
                self.error = nil
            }
        }
    }
    private(set) var error: (any Error)?
    private(set) var locationAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    private(set) var location: CLLocation?
    
    private let locationDataProvider: AnyPublisher<CLLocation, LocationDataProviderError>
    private var subscription: AnyCancellable?
    
    private let locationManager: CLLocationManager = .init()
    
    private var autoSubscribe: Bool = false
    
    init(locationDataProvider: AnyPublisher<CLLocation, LocationDataProviderError>) {
        self.locationDataProvider = locationDataProvider
        super.init()
        initialize()
    }
    
    override init() {
        self.locationDataProvider = LocationDataProvider.shared.eraseToAnyPublisher()
        super.init()
        initialize()
    }
    
    private func initialize() {
        locationManager.delegate = self
        self.locationAuthorizationStatus = locationManager.authorizationStatus
    }
    
    func onAppear() {
        debugPrint(logTag, "onAppear")
        if autoSubscribe {
            debugPrint(logTag, "auto resubscribtion")
            subscribe()
        }
    }
    
    func onDisappear() {
        debugPrint(logTag, "onDisappear")
        autoSubscribe = state == .subscribed
        unsubscribe()
    }
    
    func onButtonClick_requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func onButtonClick_subscribe() {
        debugPrint(logTag, "onButtonClick_subscribe")
        subscribe()
    }
    
    func onButtonClick_unsubscribe() {
        debugPrint(logTag, "onButtonClick_unsubscribe")
        unsubscribe()
    }
    
    private func subscribe() {
        debugPrint(logTag, "subscribe")
        
        guard state != .subscribed else { return }
        
        state = .subscribed
        subscription = locationDataProvider.sink(
            receiveCompletion: {completion in
                debugPrint(self.logTag, "receiveCompletion: \(completion)")
                if case .failure(let error) = completion {
                    self.error = error
                    self.state = .failed
                } else {
                    self.state = .notSubscribed
                }
            },
            receiveValue: { location in
                self.location = location
            })
    }
    
    private func unsubscribe() {
        debugPrint(self.logTag, "unsubscribe")
        guard state == .subscribed else { return }
        subscription?.cancel()
        state = .notSubscribed
    }
    
    func onButtonClick_openSystemAppSettings() {
        debugPrint(self.logTag, "onButtonClick_openSystemAppSettings")
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.locationAuthorizationStatus = locationManager.authorizationStatus
    }
}


#Preview {
    NavigationStack {
        LocationDataProviderTestView(
            model: LocationDataProviderTestViewModel(locationDataProvider: LocationDataProviderMock.shared.eraseToAnyPublisher())
        )
    }
}
