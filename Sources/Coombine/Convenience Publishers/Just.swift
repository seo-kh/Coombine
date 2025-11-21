//
//  Just.swift
//  Coombine
//
//  Created by 서광현 on 10/5/24.
//

import Foundation

/// A publisher that emits an output to each subscriber just once, and the finishes.
///
/// You can use a Just publisher to start a chain of publishers. A Just publisher is also useful when replacing a value with Publishers.Catch.
///
/// In contrast with Results.Publisher, a Just publisher can't fail with an error. And unlike Optional.Publisher, a Just publisher always produces a value.
public struct _Just<Output>: _Publisher {
    public typealias Failure = Never
    let subscription = JustSubscription()

    public func receive<S>(subscriber: S) where S : _Subscriber, Failure == S.Failure, Output == S.Input {
        // 동일한 subscriber에게는 subscription을 주되, 바로 finished나 cancel을 주어야한다.
        subscriber.receive(subscription: subscription)
        
        if subscription.contains(subscriber.combineIdentifier) {
            subscriber.receive(completion: .finished)
        } else {
            subscription.insert(subscriber.combineIdentifier)
            _ = subscriber.receive(output)
            subscriber.receive(completion: .finished)
        }
    }
    
    /// The one element that the publisher emits.
    let output: Output
    
    init(_ output: Output) {
        self.output = output
    }
    
    final class JustSubscription: _Subscription, CustomStringConvertible {
        private var identifiers: Set<_CombineIdentifier> = []
        
        var description: String {
            "Just"
        }
        
        func contains(_ id: _CombineIdentifier) -> Bool {
            identifiers.contains(id)
        }
        
        func insert(_ id: _CombineIdentifier) {
            identifiers.insert(id)
        }
        
        func request(_ demand: _Subscribers._Demand) {
            // no needed
        }
        
        func cancel() {
            // no needed
        }
    }
}

extension _Just: Equatable where Output: Equatable {
    public static func == (lhs: _Just<Output>, rhs: _Just<Output>) -> Bool {
        lhs.output == rhs.output
    }
}
