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
    
    struct Map<Upstream, Output>: Publisher where Upstream: Publisher {
        typealias Failure = Upstream.Failure
        let upstream: Upstream
        let transform: (Upstream.Output) -> Output
        
        init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output) {
            self.upstream = upstream
            self.transform = transform
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let cancellable = self.upstream
                .sink { completion in
                    subscriber.receive(completion: completion)
                } receiveValue: { output in
                    let _output = transform(output)
                    _ = subscriber.receive(_output)
                }
            let subscription = MapSubsription(cancellable)
            subscriber.receive(subscription: subscription)
        }
        
        final class MapSubsription: Subscription {
            var canncelable: Cancellable?
            
            init(_ canncelable: Cancellable? = nil) {
                self.canncelable = canncelable
            }
            
            func request(_ demand: Subscribers.Demand) {
                
            }
            
            func cancel() {
                self.canncelable?.cancel()
                self.canncelable = nil
                
            }
        }
    }
}

extension Sequence {
    var publisher: Publishers._Sequence<Self, Never> {
        .init(sequence: self)
    }
}
