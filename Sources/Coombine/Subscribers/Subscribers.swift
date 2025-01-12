//
//  Subscribers.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

enum Subscribers {
    /// A requetsted number of items, sent to a publisher from a  subscriber through the subscription.
    struct Demand: Hashable, Codable, Equatable, Comparable, Sendable, CustomStringConvertible {
        static func < (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Bool {
            lhs.max ?? 0 < rhs.max ?? 0
        }
        
        var description: String {
            if let max {
                return max == 0 ? "" : "max (\(max.description))"
            } else {
                return "unlimited"
            }
        }
        
        /// The number of requested values.
        ///
        /// The value is nil if the demand is unlimited
        private(set) var max: Int?
        
        private init(_ max: Int?) {
            self.max = max
        }
        
        static let unlimited: Self = .init(nil)
        static let none: Self = .init(0)
        static func max(_ value: Int) -> Self {
            if value < 0 { fatalError("value must be a positive integer") }
            return .init(value)
        }
    }
    
    /// A signal that a publisher doesn't produce additional elements, either due to normal completion or an error.
    enum Completion<Failure> where Failure: Error {
        case finished
        case failure(Failure)
    }
    
    /// A simple subscriber that requests an unlimited number of values upon subscription.
    final class Sink<Input, Failure>: Subscriber, Cancellable where Failure: Error {
        func cancel() {
            self.subscription?.cancel()
            self.subscription = nil
        }
        
        private(set) var receiveValue: (Input) -> Void
        private(set) var receiveCompletion: (Subscribers.Completion<Failure>) -> Void
        private var subscription: Subscription?
        
        init(
            receiveValue: @escaping (Input) -> Void,
            receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void
        ) {
            self.receiveValue = receiveValue
            self.receiveCompletion = receiveCompletion
        }
        
        func receive(completion: Subscribers.Completion<Failure>) {
            self.receiveCompletion(completion)
        }
        
        func receive(subscription: any Subscription) {
            self.subscription = subscription
            subscription.request(.unlimited)
        }
        
        @discardableResult
        func receive(_ input: Input) -> Subscribers.Demand {
            self.receiveValue(input)
            return .none
        }
    }
    
    final class Assign<Root, Input>: Subscriber, Cancellable {
        final private(set) var object: Root?
        final let keyPath: ReferenceWritableKeyPath<Root, Input>
        final private var subscription: Subscription?

        init(object: Root, keyPath: ReferenceWritableKeyPath<Root, Input>) {
            self.object = object
            self.keyPath = keyPath
        }
        
        func cancel() {
            self.subscription?.cancel()
            self.subscription = nil
            self.object = nil
        }
        
        func receive(completion: Subscribers.Completion<Never>) {
            self.object = nil
            self.subscription = nil
        }
        
        func receive(subscription: any Subscription) {
            self.subscription = subscription
            subscription.request(.unlimited)
        }
        
        func receive(_ input: Input) -> Subscribers.Demand {
            object?[keyPath: keyPath] = input
            return .none
        }
        
        typealias Failure = Never
    }
}
