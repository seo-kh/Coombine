//
//  Publishers.swift
//
//
//  Created by alphacircle on 10/15/24.
//

import Foundation

enum Publishers {
    struct Sequence<Elements, Failure>: Publisher where Elements: Swift.Sequence, Failure: Error {
        let sequence: Elements
        
        typealias Output = Elements.Element
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = SequenceSubscription()
            
            subscriber
                .receive(subscription: subscription)
            
            for element in sequence {
                if subscription.demand == .none { return }
                
                let newDemand = subscriber.receive(element)
                subscription.demand += newDemand
                subscription.demand -= .max(1)
            }
            
            subscriber.receive(completion: .finished)
        }
        
        private class SequenceSubscription: Subscription {
            var demand: Subscribers.Demand = .none
            
            func request(_ demand: Subscribers.Demand) {
                self.demand = demand
            }
            
            func cancel() {
                self.demand = .none
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
    
    struct Print<Upstream>: Publisher where Upstream: Publisher {
        typealias Output = Upstream.Output
        typealias Failure = Upstream.Failure
        
        let upstream: Upstream
        let prefix: String
        let stream: (any TextOutputStream)?
        
        init(upstream: Upstream, prefix: String, stream: (any TextOutputStream)? = nil) {
            self.upstream = upstream
            self.prefix = prefix
            self.stream = stream
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input {
            Swift.print("receive subscription:", type(of: upstream))
            
            let subscription = PrintSubscription()
            
            subscriber
                .receive(subscription: subscription)
            
            let cancel = self.upstream
                .sink { completion in
                    Swift.print("receive", completion)
                    subscriber.receive(completion: completion)
                } receiveValue: { output in
                    Swift.print("receive value:", output)
                    let newDemand = subscriber.receive(output)
                    if newDemand != .none { Swift.print("receive max:", newDemand.description) }
                }
            
            subscription.upstreamCancel = cancel.cancel
        }
        
        final class PrintSubscription: Subscription {
            var upstreamCancel: (() -> Void)?
            
            func request(_ demand: Subscribers.Demand) {
                Swift.print("request", demand)
            }
            
            func cancel() {
                Swift.print("request cancel")
                upstreamCancel?()
            }
        }
    }
}

extension Sequence {
    var publisher: Publishers.Sequence<Self, Never> {
        .init(sequence: self)
    }
}
