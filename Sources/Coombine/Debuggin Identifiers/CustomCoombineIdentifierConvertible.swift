//
//  CustomCoombineIdentifierConvertible.swift
//  Coombine
//
//  Created by 서광현 on 10/5/24.
//

import Foundation

/// A protocol for uniquely identifying publisher streams.
protocol CustomCoombineIdentifierConvertible {
    /// A unique identifier for identifying publisher streams.
    var coombineIdentifier: CoombineIdentifier { get }
}

extension CustomCoombineIdentifierConvertible where Self: AnyObject {
    /// Default implementation
    var coombineIdentifier: CoombineIdentifier {
        .init(self)
    }
}
