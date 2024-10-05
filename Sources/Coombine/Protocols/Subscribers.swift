//
//  Subscribers.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

enum Subscribers {
    /// A requetsted number of items, sent to a publisher from a  subscriber through the subscription.
    struct Demand: Hashable, Copyable, Codable, Equatable, Comparable, BitwiseCopyable {
        static func < (lhs: Subscribers.Demand, rhs: Subscribers.Demand) -> Bool {
            lhs.max ?? 0 < rhs.max ?? 0
        }
        
        /// The number of requested values.
        var max: Int? {
            _max
        }
        
        private var _max: Int?
        
        private init(_ max: Int?) {
            self._max = max
        }
        
        static let unlimited: Self = .init(Int.max)
        static let none: Self = .init(nil)
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
    final class Sink<Input, Failure>: Subscriber where Failure: Error {
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
            self.subscription?.request(.unlimited)
        }
        
        @discardableResult
        func receive(_ input: Input) -> Subscribers.Demand {
            self.receiveValue(input)
            return .unlimited
        }
    }}
