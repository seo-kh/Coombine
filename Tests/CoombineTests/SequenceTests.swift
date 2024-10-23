//
//  SequenceTests.swift
//  
//
//  Created by alphacircle on 10/23/24.
//

import XCTest
@testable import Coombine

final class TestSubscriber<Input, Failure>: Subscriber where Failure: Error {
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

final class SequenceTests: XCTestCase {

    var cancellable: Cancellable?
    
    override func tearDown() {
        cancellable?.cancel()
        cancellable = nil
    }

    func test1() {
        // Given: publisher - publishing only 10 elements
        let publisher = (0..<10).publisher
        
        // When: subsriber - requesting only 5 elements, no demand
        publisher
            .receive(subscriber: TestSubscriber(max: 5, newDemand: 0))
    }
    
    func test2() {
        // Given: publisher - publishing only 10 elements
        let publisher = (0..<10).publisher
        
        // When: subsriber - requesting only 5 elements, but adding .max(1) demand
        publisher
            .receive(subscriber: TestSubscriber(max: 5, newDemand: 1))
    }
    
    func test3() {
        // Given: publisher - publishing only 10 elements
        let publisher = (0..<10).publisher
        
        // When: subsriber - requesting only 15 elements, no demand
        publisher
            .receive(subscriber: TestSubscriber(max: 15, newDemand: 0))
    }
}
