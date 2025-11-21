//
//  Cancellable.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

/// A protocol indicating that an activity or action supports cancellation.
protocol _Cancellable {
    /// Cancel the activity.
    func cancel()
}

extension _Cancellable {
    // TODO: func store<C>(in:), func store(in:)
}
