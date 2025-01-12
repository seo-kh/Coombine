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
    /// The kind of values published by this publisher.
    associatedtype Output
    
    /// The kind of errors this publisher might publish.
    associatedtype Failure: Error
    
    /// Attaches the specified subscriber to this publisher.
    func receive<S>(subscriber: S) where S: Subscriber, Self.Output == S.Input, Self.Failure == S.Failure
}

extension Publisher {
    // TODO: func subscribe(_), func subscribe(_) -> AnyCancellable
    func subscribe<S>(_ subscriber: S) where S: Subscriber, Self.Output == S.Input, Self.Failure == S.Failure {
        self
            .receive(subscriber: subscriber)
    }
    
    func subscribe<S>(_ subject: S) -> AnyCancellable where S: Subject, Self.Failure == S.Failure, Self.Output == S.Output {
        return self
            .sink { completion in
                subject.send(completion: completion)
            } receiveValue: { output in
                subject.send(output)
            }

    }
    
    func sink(
        receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void),
        receiveValue: @escaping ((Self.Output) -> Void)
    ) -> AnyCancellable {
        let subscriber = Subscribers.Sink(receiveValue: receiveValue, receiveCompletion: receiveCompletion)
        
        self.receive(subscriber: subscriber)
        
        return .init(subscriber)
    }
    
    func sink(
        receiveValue: @escaping ((Self.Output) -> Void)
    ) -> AnyCancellable where Self.Failure == Never {
        let subscriber = Subscribers.Sink<Self.Output, Self.Failure>(receiveValue: receiveValue, receiveCompletion: { _ in })
        
        self.receive(subscriber: subscriber)
        
        return .init(subscriber)
    }
    
    func assign<Root>(
        to keyPath: ReferenceWritableKeyPath<Root, Self.Output>,
        on object: Root
    ) -> AnyCancellable where Failure == Never {
        let subscriber = Subscribers.Assign(object: object, keyPath: keyPath)
        
        self
            .receive(subscriber: subscriber)
        
        return .init(subscriber)
    }
    
    func eraseToAnyPublisher() -> AnyPublisher<Self.Output, Self.Failure> {
        .init(self)
    }
    
    func map<T>(_ transform: @escaping (Self.Output) -> T) -> Publishers.Map<Self, T> {
        .init(upstream: self, transform: transform)
    }
    
    func print(
        _ prefix: String = "",
        to stream: (any TextOutputStream)? = nil
    ) -> Publishers.Print<Self> {
        .init(upstream: self, prefix: prefix, stream: stream)
    }
}
