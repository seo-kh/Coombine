//
//  CombineIdentifier.swift
//  Coombine
//
//  Created by 서광현 on 10/5/24.
//

import Foundation

private var __identifier: UInt64 = 0

internal func __nextCombineIdentifier() -> UInt64 {
    defer { __identifier += 1 }
    return __identifier
}

/// A unique identifier for identifying publisher streams.
///
/// To conform to `CustomCombineIdentifierConvertible` in a
/// `Subscription` or `Subject` that you implement as a structure, create an instance of
/// `CombineIdentifier` as follows:
///
///     let combineIdentifier = CombineIdentifier()
///
/// idea from: [openCombine github]( https://github.com/OpenCombine/OpenCombine/blob/master/Sources/OpenCombine/CombineIdentifier.swift)
public struct _CombineIdentifier: CustomStringConvertible, Equatable, Hashable {
    private let rawValue: UInt64
    
    init() {
        rawValue = __nextCombineIdentifier()
    }
    
    init(_ obj: AnyObject) {
        rawValue = UInt64(UInt(bitPattern: ObjectIdentifier(obj)))
    }
    
    public var description: String {
        return "0x\(String(rawValue, radix: 16))"
    }
}
