//
//  PassThroughSubject.swift
//
//
//  Created by alphacircle on 10/16/24.
//

import Foundation

final class PassThroughSubject<Output, Failure>: Subject where Failure: Error {
    init() {}
    
    private var subscriber: (any Subscriber<Output, Failure>)?
    
    final func send(completion: Subscribers.Completion<Failure>) {
        self.subscriber?.receive(completion: completion)
        self.subscriber = nil
    }
    
    final func send(subscription: any Subscription) {
        self.subscriber?.receive(subscription: subscription)
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = PassThroughSubjectSubsription(cancel: {
            [weak self] in
            self?.subscriber = nil
        })
        subscriber.receive(subscription: subscription)
        self.subscriber = subscriber
    }
    
    final func send(_ value: Output) {
        _ = self.subscriber?.receive(value)
    }
    
    private final class PassThroughSubjectSubsription: Subscription {
        private let _cancel: () -> Void
        
        init(cancel: @escaping () -> Void) {
            self._cancel = cancel
        }
        
        func cancel() {
            self._cancel()
        }
        
        func request(_ demand: Subscribers.Demand) {
            
        }
    }
}
