//
//  CurrentValueSubject.swift
//
//
//  Created by alphacircle on 10/16/24.
//

import Foundation

final class _CurrentValueSubject<Output, Failure>: _Subject where Failure: Error {
    
    /// 이 변수가 변화할때마다, 새로운 elemenet로 발행되는 Subject에 의해 감싸진 변수
    final var value: Output
    
    private var subscriber: (any _Subscriber<Output, Failure>)?
    
    init(_ value: Output) {
        self.value = value
    }
    
    func send(completion: _Subscribers._Completion<Failure>) {
        self.subscriber?.receive(completion: completion)
        self.subscriber = nil
    }
    
    func send(subscription: any _Subscription) {
        self.subscriber?.receive(subscription: subscription)
    }
    
    func receive<S>(subscriber: S) where S : _Subscriber, Failure == S.Failure, Output == S.Input {
        self.subscriber = subscriber
        subscriber.receive(subscription: CurrentValueSubjectSubsription(cancel: {
            [weak self] in
            self?.subscriber = nil
        }))
        _ = subscriber.receive(value)
    }
    
    func send(_ value: Output) {
        self.value = value
        _ = self.subscriber?.receive(value)
    }
    
    private final class CurrentValueSubjectSubsription: _Subscription {
        let _cancel: () -> Void
        
        init(cancel: @escaping () -> Void) {
            self._cancel = cancel
        }
        
        // Never Demand
        func request(_ demand: _Subscribers._Demand) {}
        
        func cancel() {
            self._cancel()
        }
    }
}
