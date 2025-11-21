//
//  AnyCancellable.swift
//
//
//  Created by alphacircle on 10/15/24.
//

import Foundation

public final class _AnyCancellable: _Cancellable, Equatable, Hashable {
    private var _cancel: (() -> Void)?
    
    public static func == (lhs: _AnyCancellable, rhs: _AnyCancellable) -> Bool {
        lhs === rhs
    }
    
    public func cancel() {
        _cancel?()
        _cancel = nil
    }
    
    init(_ cancel: @escaping (() -> Void)) {
        self._cancel = cancel
    }
    
    init<C>(_ canceller: C) where C: _Cancellable {
        self._cancel = canceller.cancel
    }
    
    final func store<C>(in collection: inout C) where C: RangeReplaceableCollection, C.Element == _AnyCancellable {
        collection.append(self)
    }
    
    final func store(in set: inout Set<_AnyCancellable>) {
        set.insert(self)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
