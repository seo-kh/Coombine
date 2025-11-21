//
//  _Subscribers.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

public enum _Subscribers {
    /// A requetsted number of items, sent to a publisher from a  subscriber through the subscription.
    public struct _Demand: Hashable, Codable, Equatable, Comparable, Sendable, CustomStringConvertible {
        public static func < (lhs: _Subscribers._Demand, rhs: _Subscribers._Demand) -> Bool {
            lhs.max ?? 0 < rhs.max ?? 0
        }
        
        public var description: String {
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
    public enum _Completion<Failure> where Failure: Error {
        case finished
        case failure(Failure)
    }
    
    /// A simple subscriber that requests an unlimited number of values upon subscription.
    public final class _Sink<Input, Failure>: _Subscriber, _Cancellable where Failure: Error {
        public func cancel() {
            self.subscription?.cancel()
            self.subscription = nil
        }
        
        private(set) var receiveValue: (Input) -> Void
        private(set) var receiveCompletion: (_Subscribers._Completion<Failure>) -> Void
        private var subscription: _Subscription?
        
        init(
            receiveCompletion: @escaping (_Subscribers._Completion<Failure>) -> Void,
            receiveValue: @escaping (Input) -> Void
        ) {
            self.receiveValue = receiveValue
            self.receiveCompletion = receiveCompletion
        }
        
        public func receive(completion: _Subscribers._Completion<Failure>) {
            self.receiveCompletion(completion)
        }
        
        public func receive(subscription: any _Subscription) {
            self.subscription = subscription
            subscription.request(.unlimited)
        }
        
        @discardableResult
        public func receive(_ input: Input) -> _Subscribers._Demand {
            self.receiveValue(input)
            return .none
        }
    }
    
    public final class _Assign<Root, Input>: _Subscriber, _Cancellable {
        final private(set) var object: Root?
        final let keyPath: ReferenceWritableKeyPath<Root, Input>
        final private var subscription: _Subscription?

        init(object: Root, keyPath: ReferenceWritableKeyPath<Root, Input>) {
            self.object = object
            self.keyPath = keyPath
        }
        
        public func cancel() {
            self.subscription?.cancel()
            self.subscription = nil
            self.object = nil
        }
        
        public func receive(completion: _Subscribers._Completion<Never>) {
            self.object = nil
            self.subscription = nil
        }
        
        public func receive(subscription: any _Subscription) {
            self.subscription = subscription
            subscription.request(.unlimited)
        }
        
        public func receive(_ input: Input) -> _Subscribers._Demand {
            object?[keyPath: keyPath] = input
            return .none
        }
        
        public typealias Failure = Never
    }
}
