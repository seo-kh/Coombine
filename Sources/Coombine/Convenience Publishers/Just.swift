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
struct _Just<Output>: _Publisher {
    typealias Failure = Never
    
    func receive<S>(subscriber: S)
    where S : _Subscriber, Failure == S.Failure, Output == S.Input {
        // Subscription을 주되, 갱신되지 않도록 처리한다.
        // publisher send the subscription, but it cannot be renewd.
        let subscription = JustSubscription()
        subscriber.receive(subscription: subscription)
        _ = subscriber.receive(output)
        subscriber.receive(completion: .finished)
    }
    
    /// The one element that the publisher emits.
    let output: Output
    
    init(_ output: Output) {
        self.output = output
    }
    
    private final class JustSubscription: _Subscription {
        func request(_ demand: _Subscribers._Demand) {
            // no needed
        }
        
        func cancel() {
            // no needed
        }
    }
}

extension _Just: Equatable where Output: Equatable {
    
}
