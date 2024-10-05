//
//  Subject.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

protocol Subject<Output, Failure>: AnyObject, Publisher {
    func send(_ value: Self.Output)
    func send(subscription: Subscription)
    func send(completion: Subscribers.Completion<Self.Failure>)
}

extension Subject {
    func send() where Output == () {
        send(())
    }
}
