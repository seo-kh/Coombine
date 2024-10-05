//
//  Publisher.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

/// Declares that a type can transmit a sequence of values over time.
///
/// A publisher delivers elements to one or more `Subscriber` instances.
protocol Publisher<Output, Failure> {
    /// The kind of values published by this publisher.
    associatedtype Output
    
    /// The kind of errors this publisher might publish.
    associatedtype Failure: Error
    
    /// Attaches the specified subscriber to this publisher.
    func receive<S>(subscriber: S) where S: Subscriber, Self.Output == S.Input, Self.Failure == S.Failure
}

extension Publisher {
    // TODO: func subscribe(_), func subscribe(_) -> AnyCancellable
}
