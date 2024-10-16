//
//  Publishers.swift
//
//
//  Created by alphacircle on 10/15/24.
//

import Foundation

enum Publishers {
    struct _Sequence<Elements, Failure>: Publisher where Elements: Sequence, Failure: Error {
        let sequence: Elements
        
        typealias Output = Elements.Element
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = _SequenceSubscription()
            
            subscriber
                .receive(subscription: subscription)
            
            for element in sequence {
                _ = subscriber.receive(element)
            }
            
            subscriber.receive(completion: .finished)
        }
        
        private class _SequenceSubscription: Subscription {
            func request(_ demand: Subscribers.Demand) {
                
            }
            
            func cancel() {
                
            }
        }
    }
}

extension Sequence {
    var publisher: Publishers._Sequence<Self, Never> {
        .init(sequence: self)
    }
}
