//
//  Demand+Operations.swift
//  Coombine
//
//  Created by 서광현 on 10/5/24.
//

import Foundation

extension Subscribers.Demand {
    static func * (lhs: Self, rhs: Int) -> Self {
        guard let lhsMax = lhs.max else {
            return .unlimited
        }
        
        guard lhsMax * rhs < Int.max else {
            return .unlimited
        }
        
        return .max(lhsMax * rhs)
    }

    static func *= (lhs: inout Self, rhs: Int) {
        lhs = lhs * rhs
    }
    
    static func + (lhs: Self, rhs: Self) -> Self {
        guard let lhsMax = lhs.max,
              let rhsMax = rhs.max else {
            return .unlimited
        }
        
        return .max(lhsMax + rhsMax)
    }
    
    static func + (lhs: Self, rhs: Int) -> Self {
        guard let lhsMax = lhs.max else {
            return .unlimited
        }
        
        return .max(lhsMax + rhs)
    }
    
    static func += (lhs: inout Self, rhs: Int) {
        lhs = lhs + rhs
    }
    
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    static func - (lhs: Self, rhs: Self) -> Self {
        guard let lhsMax = lhs.max else {
            return .unlimited
        }
        
        guard let rhsMax = rhs.max else {
            return .none
        }
        
        let max = lhsMax - rhsMax
        
        guard max >= 0 else {
            return .none
        }
        
        return .max(max)
    }
    
    static func - (lhs: Self, rhs: Int) -> Self {
        guard let lhsMax = lhs.max else {
            return .unlimited
        }
        
        let max = lhsMax - rhs
        
        guard max >= 0 else {
            return .none
        }
        
        return .max(max)
    }
    
    static func -= (lhs: inout Self, rhs: Int) {
        lhs = lhs - rhs
    }
    
    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}
