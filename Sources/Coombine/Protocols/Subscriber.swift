//
//  Subscriber.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

protocol Subscriber<Input, Failure> {
    associatedtype Input
    associatedtype Failure: Error
    
    func receive(_ input: Self.Input) -> Subscribers.Demand
    func receive(subscription: Subscription)
    func receive(completion: Subscribers.Completion<Self.Failure>)
}

extension Subscriber {
    func receive() -> Subscribers.Demand where Input == () {
        receive(())
    }
}
