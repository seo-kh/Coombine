//
//  Just.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

struct Just<Output>: Publisher {
    typealias Output = Output
    
    typealias Failure = Never
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = JustSubscription()
        
        subscriber
            .receive(subscription: subscription)
        
        _ = subscriber
            .receive(output)
        
        subscriber
            .receive(completion: .finished)
        
        subscription
            .cancel()
    }
    
    let output: Output
    
    init(_ output: Output) {
        self.output = output
    }
    
    class JustSubscription: Subscription {
        var demand: Subscribers.Demand = .none
        
        func request(_ demand: Subscribers.Demand) {
            self.demand = demand
        }
        
        func cancel() {
            self.demand = .none
        }
    }
}
