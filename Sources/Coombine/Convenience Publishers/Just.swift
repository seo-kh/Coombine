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
    private let subscription = JustSubscription()

    func receive<S>(subscriber: S) where S : _Subscriber, Failure == S.Failure, Output == S.Input {
        // 동일한 subscriber에게는 subscription을 주되, 바로 finished나 cancel을 주어야한다.
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
        var identifiers: Set<_CombineIdentifier> = []
        
        func request(_ demand: _Subscribers._Demand) {
            // no needed
        }
        
        func cancel() {
            // no needed
        }
    }
}

extension _Just: Equatable where Output: Equatable {
    static func == (lhs: _Just<Output>, rhs: _Just<Output>) -> Bool {
        lhs.output == rhs.output
    }
}
