//
//  Subscriber.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

/// A protocol that declares a type that can receive input from a publisher.
protocol _Subscriber<Input, Failure>: _CustomCombineIdentifierConvertible {
    /// The kind of values this subscriber receives.
    associatedtype Input
    
    /// The kind of errors this subscriber might receive.
    associatedtype Failure: Error
    
    /// Tells the subscriber that the publisher has produced an element.
    func receive(_ input: Self.Input) -> Subscribers._Demand
    
    /// Tells the subscriber that it has successfully subscribed to the publisher and may request items.
    func receive(subscription: _Subscription)
    
    /// Tells the subscriber that the publisher has completed publishing, either normally or with an error.
    func receive(completion: Subscribers._Completion<Self.Failure>)
}

extension _Subscriber {
    /// Tells the subsriber that a publisher of void elements if ready to receive futher requests.
    func receive() -> Subscribers._Demand where Input == () {
        receive(())
    }
}
