//
//  Subscription.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

protocol Subscription: AnyObject, Cancellable {
    func request(_ demand: Subscribers.Demand)
}
