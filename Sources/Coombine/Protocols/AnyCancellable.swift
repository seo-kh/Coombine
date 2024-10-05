//
//  File.swift
//  Coombine
//
//  Created by 서광현 on 10/4/24.
//

import Foundation

final class AnyCancellable: Cancellable,  Equatable {
    private let action: () -> Void
    
    init(_ cancel: @escaping () -> Void) {
        self.action = cancel
    }
    
    static func == (lhs: AnyCancellable, rhs: AnyCancellable) -> Bool {
        lhs === rhs
    }
    
    func cancel() {
        
    }
}
