//
//  CoombineIdentifier.swift
//  Coombine
//
//  Created by 서광현 on 10/5/24.
//

import Foundation

struct CoombineIdentifier: CustomStringConvertible, Equatable, Hashable {
    
    init() {
    }
    
    init(_ obj: AnyObject) {
    }
    
    func hash(into hasher: inout Hasher) {
    }
    
    var description: String {
        hashValue.description
    }
}
