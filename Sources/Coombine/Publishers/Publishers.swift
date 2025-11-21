//
//  Publishers.swift
//
//
//  Created by alphacircle on 10/15/24.
//

import Foundation

public enum _Publishers {
    public struct _Sequence<Elements, Failure>: _Publisher where Elements: Swift.Sequence, Failure: Error {
        let sequence: Elements
        
        public typealias Output = Elements.Element
        
        public func receive<S>(subscriber: S) where S : _Subscriber, Failure == S.Failure, Output == S.Input {
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
        
        private class SequenceSubscription: _Subscription {
            var demand: _Subscribers._Demand = .none
            
            func request(_ demand: _Subscribers._Demand) {
                self.demand = demand
            }
            
            func cancel() {
                self.demand = .none
            }
        }
    }
    
    public struct _Map<Upstream, Output>: _Publisher where Upstream: _Publisher {
        
        public typealias Failure = Upstream.Failure
        let upstream: Upstream
        let transform: (Upstream.Output) -> Output
        
        init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output) {
            self.upstream = upstream
            self.transform = transform
        }
        
        public func receive<S>(subscriber: S) where S : _Subscriber, Failure == S.Failure, Output == S.Input {
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
        
        final class MapSubsription: _Subscription {
            var canncelable: _Cancellable?
            
            init(_ canncelable: _Cancellable? = nil) {
                self.canncelable = canncelable
            }
            
            func request(_ demand: _Subscribers._Demand) {
                
            }
            
            func cancel() {
                self.canncelable?.cancel()
                self.canncelable = nil
                
            }
        }
    }
    
    public struct _Print<Upstream>: _Publisher where Upstream: _Publisher {
        public typealias Output = Upstream.Output
        public typealias Failure = Upstream.Failure
        
        let upstream: Upstream
        let prefix: String
        let stream: (any TextOutputStream)?
        
        init(upstream: Upstream, prefix: String, stream: (any TextOutputStream)? = nil) {
            self.upstream = upstream
            self.prefix = prefix
            self.stream = stream
        }
        
        public func receive<S>(subscriber: S) where S : _Subscriber, Upstream.Failure == S.Failure, Upstream.Output == S.Input {
            Swift.print("receive subscription:", upstream)
            
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
        
        final class PrintSubscription: _Subscription {
            var upstreamCancel: (() -> Void)?
            
            func request(_ demand: _Subscribers._Demand) {
                Swift.print("request", demand)
            }
            
            func cancel() {
                Swift.print("request cancel")
                upstreamCancel?()
            }
        }
    }
}

public extension Sequence {
    var publisher: _Publishers._Sequence<Self, Never> {
        .init(sequence: self)
    }
}
