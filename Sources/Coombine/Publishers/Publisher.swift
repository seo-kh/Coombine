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
protocol _Publisher<Output, Failure> {
    /// The kind of values published by this publisher.
    associatedtype Output
    
    /// The kind of errors this publisher might publish.
    associatedtype Failure: Error
    
    /// Attaches the specified subscriber to this publisher.
    func receive<S>(subscriber: S) where S: _Subscriber, Self.Output == S.Input, Self.Failure == S.Failure
}

extension _Publisher {
    // TODO: func subscribe(_), func subscribe(_) -> AnyCancellable
    func subscribe<S>(_ subscriber: S) where S: _Subscriber, Self.Output == S.Input, Self.Failure == S.Failure {
        self
            .receive(subscriber: subscriber)
    }
    
    func subscribe<S>(_ subject: S) -> _AnyCancellable where S: _Subject, Self.Failure == S.Failure, Self.Output == S.Output {
        return self
            .sink { completion in
                subject.send(completion: completion)
            } receiveValue: { output in
                subject.send(output)
            }

    }
    
    func sink(
        receiveCompletion: @escaping ((_Subscribers._Completion<Self.Failure>) -> Void),
        receiveValue: @escaping ((Self.Output) -> Void)
    ) -> _AnyCancellable {
        let subscriber = _Subscribers._Sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
        
        self.receive(subscriber: subscriber)
        
        return .init(subscriber)
    }
    
    func sink(
        receiveValue: @escaping ((Self.Output) -> Void)
    ) -> _AnyCancellable where Self.Failure == Never {
        let subscriber = _Subscribers._Sink<Self.Output, Self.Failure>(receiveCompletion: { _ in }, receiveValue: receiveValue)
        
        self.receive(subscriber: subscriber)
        
        return .init(subscriber)
    }
    
    func assign<Root>(
        to keyPath: ReferenceWritableKeyPath<Root, Self.Output>,
        on object: Root
    ) -> _AnyCancellable where Failure == Never {
        let subscriber = _Subscribers._Assign(object: object, keyPath: keyPath)
        
        self
            .receive(subscriber: subscriber)
        
        return .init(subscriber)
    }
    
    func eraseToAnyPublisher() -> _AnyPublisher<Self.Output, Self.Failure> {
        .init(self)
    }
    
    func map<T>(_ transform: @escaping (Self.Output) -> T) -> _Publishers._Map<Self, T> {
        .init(upstream: self, transform: transform)
    }
    
    func print(
        _ prefix: String = "",
        to stream: (any TextOutputStream)? = nil
    ) -> _Publishers._Print<Self> {
        .init(upstream: self, prefix: prefix, stream: stream)
    }
}
