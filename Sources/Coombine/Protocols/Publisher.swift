//
//  Publisher.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

/// Declares that a type can transmit a sequence of values over time.
///
/// A publisher delivers elements to one or more `Subscriber` instances.
protocol Publisher<Output, Failure> {
    associatedtype Output
    associatedtype Failure: Error
    
    func receive<S>(subscriber: S) where S: Subscriber, Self.Output == S.Input, Self.Failure == S.Failure
}

extension Publisher {
    func subscribe<S>(_ subscriber: S) where S: Subscriber, Self.Output == S.Input, Self.Failure == S.Failure {
        self
            .receive(subscriber: subscriber)
    }
    
    func sink(
        receiveValue: @escaping ((Self.Output) -> Void)
    ) -> AnyCancellable where Failure == Never {
        let sink = Subscribers.Sink<Output, Failure>(receiveValue: receiveValue, receiveCompletion: { _ in })
        
        self
            .receive(subscriber: sink)
        
        return .init { [weak sink] in
            sink?.receive(completion: .finished)
        }
    }

    func sink(
        receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void),
        receiveValue: @escaping ((Self.Output) -> Void)
    ) -> AnyCancellable {
        let sink = Subscribers.Sink(receiveValue: receiveValue, receiveCompletion: receiveCompletion)
        
        self
            .receive(subscriber: sink)
        
        return .init { [weak sink] in
            sink?.receive(completion: .finished)
        }
    }
}
