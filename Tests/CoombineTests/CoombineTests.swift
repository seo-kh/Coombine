import XCTest
import os
@testable import Coombine

final class CoombineTests: XCTestCase {
    let logger = Logger(subsystem: "COOMBINE", category: "Tests")
    var cancellable: Cancellable?
    
    override func tearDown() {
        cancellable = nil
    }
    
    /// Subscribers의 demand 계산
    func test_1() {
        // GIVEN
        let demand = Subscribers.Demand.max(5)
        
        // WHEN: +, -, *,
        let expectation = XCTestExpectation(description: "Operation Expectation")
        expectation.expectedFulfillmentCount = 3
        let plus = demand + 5
        if plus.max == 10 { expectation.fulfill() }
        
        let minus = demand - 4
        if minus.max == 1 { expectation.fulfill() }
        
        let multiply = demand * 2
        if multiply.max == 10 { expectation.fulfill() }
        
        // THEN
        XCTAssertEqual(expectation.expectedFulfillmentCount, 3)
    }
    
    /// Just와 Sink를 테스트하기 위한 test code
    func test_2() {
        // GIVEN
        let just = Just([1, 2, 3])
        let sink = Subscribers.Sink<[Int], Never> { input in
            // THEN
            XCTAssertEqual(input[0], 1)
        } receiveCompletion: { _ in
            //
        }

        // WHEN
        just
            .receive(subscriber: sink)
    }
    
    func test_3() {
        // Given
        let array = [1, 2, 3].publisher
        // When
        self.cancellable = array
            .sink(receiveCompletion: { _ in
                // Then
                XCTAssert(true)
            }, receiveValue: { output in
                print(output)
            })
        
    }
}
