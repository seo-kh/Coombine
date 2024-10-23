//
//  Combinetests.swift
//  
//
//  Created by alphacircle on 10/23/24.
//

import Combine
import XCTest

final class TestCombineSubscriber<Input, Failure>: Subscriber where Failure: Error {
    let max: Int
    let newDemand: Int?
    
    init(max: Int, newDemand: Int?) {
        self.max = max
        self.newDemand = newDemand
    }
    
    func receive(subscription: any Subscription) {
        subscription.request(.max(max))
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        if let newDemand {
            return newDemand == 0 ? .none : .max(newDemand)
        } else {
            return .unlimited
        }
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        
    }
}

final class Combinetests: XCTestCase {
    var cancellable: Cancellable?
    
    override func tearDown() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    func testPrint() {
        _ = (0..<10).publisher
            .print()
//            .receive(subscriber: TestCombineSubscriber(max: 5, newDemand: 1))
            .sink(receiveValue: { print("output: \($0)")})
    }
}
