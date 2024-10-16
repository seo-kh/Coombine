//
//  AnyPublisher.swift
//
//
//  Created by alphacircle on 10/16/24.
//

import Foundation

/// 다른 Publisher를 감싸는 타입이 지워진 Publisher
struct AnyPublisher<Output, Failure>: Publisher where Failure: Error {
    private var publisher: any Publisher<Output, Failure>
    
    init<P>(_ publisher: P) where P: Publisher, Output == P.Output, Failure == P.Failure {
        self.publisher = publisher
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        
        self.publisher
            .receive(subscriber: subscriber)
    }
}
