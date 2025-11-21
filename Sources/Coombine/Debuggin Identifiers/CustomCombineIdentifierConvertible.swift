//
//  CustomCombineIdentifierConvertible.swift
//  Coombine
//
//  Created by 서광현 on 10/5/24.
//

import Foundation

/// A protocol for uniquely identifying publisher streams.
protocol _CustomCombineIdentifierConvertible {
    /// A unique identifier for identifying publisher streams.
    var combineIdentifier: _CombineIdentifier { get }
}

extension _CustomCombineIdentifierConvertible where Self: AnyObject {
    /// Default implementation
    var combineIdentifier: _CombineIdentifier {
        .init(self)
    }
}
