//
//  AnyPublisher.swift
//
//
//  Created by alphacircle on 10/16/24.
//

import Foundation

/// 다른 Publisher를 감싸는 타입이 지워진 Publisher
public struct _AnyPublisher<Output, Failure>: _Publisher where Failure: Error {
    private var publisher: any _Publisher<Output, Failure>
    
    public init<P>(_ publisher: P) where P: _Publisher, Output == P.Output, Failure == P.Failure {
        self.publisher = publisher
    }
    
    public func receive<S>(subscriber: S) where S : _Subscriber, Failure == S.Failure, Output == S.Input {
        
        self.publisher
            .receive(subscriber: subscriber)
    }
}
