//
//  Subscription.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

/// A protocol representing the connection of a subscriber to a publisher.
public protocol _Subscription: _Cancellable, _CustomCombineIdentifierConvertible {
    /// Tells a publisher that it may send more values to the subscriber
    func request(_ demand: _Subscribers._Demand)
}
