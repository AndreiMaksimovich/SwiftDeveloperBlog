import Testing
@testable import _3___Testable_SwiftUI_Views_and_ViewModels
import Combine

@MainActor
@Suite(.serialized)
class UnitTests {
    init() {
        initTestEnvironment()
    }
    
    @MainActor deinit {
        teardownTestEnvironment()
    }

    @Test func сomplexViewModel() async throws {
        let model = TestComplexViewModel()
        model.setSomeValue("Hello World!")
        #expect(model.someValue == "Hello World!")
    }
    
    @Test func viewModelWithMockData() async throws {
        let model = TestViewModel(dataSource: AccelerometerDataProviderMock().eraseToAnyPublisher())
        
        model.onAppear()
        defer {
            model.onDisappear()
        }
        
        try? await Task.sleep(for: .milliseconds(50))
        
        #expect(model.accelerometerData != nil)
    }
    
    @Test func viewModelNoAccelerometerError() async throws {
        let model = TestViewModel(dataSource: AccelerometerDataProviderMockNoAccelerometer().eraseToAnyPublisher())
        
        model.onAppear()
        defer {
            model.onDisappear()
        }
        
        try? await Task.sleep(for: .milliseconds(50))
        
        #expect(model.error != nil)
        if case AccelerometerDataProviderError.accelerometerNotAvailable = model.error! { } else {
            #expect(Bool(false), "Wrong error type")
        }
    }
    
    @Test func accelerometerDataProviderMockFromAppEnv() async throws {
        let accelerometer = AppEnvironment.shared.dataProviders.accelerometerDataProvider
        var accelerometerData: AccelerometerData?
        
        let subscription = accelerometer.sink(receiveCompletion: {completion in}, receiveValue: {accelerometerData = $0})
        
        defer {
            subscription.cancel()
        }
        
        try? await Task.sleep(for: .milliseconds(50))
        
        #expect(accelerometerData != nil)
    }
}
