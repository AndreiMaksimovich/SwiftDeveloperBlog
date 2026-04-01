//
//  DynamicDataProvider.swift
//
//  Created by Andrei Maksimovich on 27/03/2026.
//

import Combine
import CoreMotion
import Foundation

@MainActor
open class DynamicPublisher<Output, Failure: Error>: NSObject, @MainActor Publisher {
    private let logTag = "DynamicPublisher<\(Output.self), \(Failure.self)>"
    
    public typealias Output = Output
    public typealias Failure = Failure
    
    private var subscriptions: [UUID: DynamicSubscription] = [:]
    public var subscriptionCount: Int { subscriptions.count }
    private(set) var isInitialized: Bool = false
    
    open func start() {}
    open func stop() {}
    
    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = DynamicSubscription(publisher: self, subscriber: subscriber)
        addSubscription(subscription: subscription)
    }
    
    public func send(_ value: Output) {
        guard subscriptionCount > 0 else {
            return
        }
        
        subscriptions.forEach {(id, subscription) in
            _ = subscription.subscriber.receive(value)
        }
    }
    
    public func fail(with error: Failure) {
        Swift.print(logTag, "Failed with:", error)
        completion(with: .failure(error))
    }
    
    public func finish() {
        Swift.print(logTag, "Finish")
        completion(with: .finished)
    }
    
    public func completion(with completion: Subscribers.Completion<Failure>) {
        guard subscriptionCount > 0 else {
            return
        }
        
        subscriptions.forEach {(id, subscription) in
            subscription.subscriber.receive(completion: completion)
        }
        
        subscriptions.removeAll()
        
        invokeStop()
    }
    
    private func invokeStop() {
        guard isInitialized else { return }
        isInitialized = false
        Swift.print(logTag, "call stop")
        stop()
    }
    
    private func invokeStart() {
        guard !isInitialized else { return }
        isInitialized = true
        Swift.print(logTag, "call start")
        start()
    }
    
    public func clear() {
        Swift.print(logTag, "Clear")
        
        guard subscriptions.count > 0 else {
            return
        }
        
        subscriptions.forEach {(id, subscription) in
            cancelSubscription(subscription: subscription)
        }
    }
    
    fileprivate func addSubscription(subscription: DynamicSubscription) {
        Swift.print(logTag, "addSubscription")
        
        guard subscriptions[subscription.id] == nil else {
            return
        }
        
        subscriptions[subscription.id] = subscription
        
        if !isInitialized {
            invokeStart()
        }
        
        subscription.subscriber.receive(subscription: subscription)
    }
    
    fileprivate func cancelSubscription(subscription: DynamicSubscription) {
        Swift.print(logTag, "cancelSubscription")
        
        guard subscriptions[subscription.id] != nil else {
            return
        }
        
        subscriptions.removeValue(forKey: subscription.id)
        subscription.subscriber.receive(completion: .finished)
        
        if subscriptions.count == 0 {
            invokeStop()
        }
    }
    
    @MainActor
    fileprivate class DynamicSubscription: @MainActor Subscription, Identifiable {
        let id: UUID = .init()
        let publisher: DynamicPublisher<Output, Failure>
        let subscriber: any Subscriber<Output, Failure>
        
        init(publisher: DynamicPublisher<Output, Failure>, subscriber: any Subscriber<Output, Failure>) {
            self.publisher = publisher
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            publisher.cancelSubscription(subscription: self)
        }
    }
}
