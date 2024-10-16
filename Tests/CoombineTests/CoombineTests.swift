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
    
    // Sequence publisher와 Sink func 테스트
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
    
    // CurrentValueSubject test: sink
    func test_4() {
        // Given
        let integerSubject = CurrentValueSubject<Int, Never>(0)
        // When
        cancellable = integerSubject
            .sink { output in
                // Then
                XCTAssertEqual(output, 0)
            }
    }
    
    // CurrentValueSubject test: send
    func test_5() {
        // Given
        let integerSubject = CurrentValueSubject<Int, Never>(0)
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 3
        
        // When
        cancellable = integerSubject
            .sink { output in
                if [0, 3, 5]
                    .contains(output) {
                    expectation.fulfill()
                }
            }
        
        integerSubject
            .send(3)
        
        integerSubject
            .send(5)
    }
    
    // CurrentValueSubject test: completion
    func test_6() {
        // Given
        let integerSubject = CurrentValueSubject<Int, Never>(0)
        var fullfillments = Set<Int>()
        let fullfillCount = 5
        
        cancellable = integerSubject
            .sink(receiveCompletion: { completion in
                // Then
                XCTAssertNotEqual(fullfillments.count, fullfillCount)
            }, receiveValue: { output in
                fullfillments.insert(output)
            })
        
        // When
        integerSubject
            .send(3)
        
        integerSubject
            .send(5)
        
        integerSubject
            .send(completion: .finished)
    }
    
    // CurrentValueSubject test: completion
    func test_7() {
        // Given
        let integerSubject = CurrentValueSubject<Int, Never>(0)
        var fullfillments = Set<Int>()
        let fullfillCount = 5
        
        cancellable = integerSubject
            .sink(receiveCompletion: { completion in
            }, receiveValue: { output in
                fullfillments.insert(output)
            })
        
        // When
        integerSubject
            .send(3)
        
        integerSubject
            .send(5)
        
        integerSubject
            .send(completion: .finished)
        
        integerSubject
            .send(9)
        
        integerSubject
            .send(19)

        integerSubject
            .send(completion: .finished)
        
        XCTAssertNotEqual(fullfillments.count, fullfillCount)
    }

    // CurrentValueSubject test: cancel
    func test_8() {
        // Given
        let integerSubject = CurrentValueSubject<Int, Never>(0)
        var fullfillments = Set<Int>()
        let fullfillCount = 5
        
        cancellable = integerSubject
            .sink(receiveCompletion: { completion in
            }, receiveValue: { output in
                fullfillments.insert(output)
            })
        
        // When
        integerSubject
            .send(3)
        
        integerSubject
            .send(5)
        
        cancellable?.cancel()
        
        integerSubject
            .send(9)
        
        integerSubject
            .send(19)

        integerSubject
            .send(completion: .finished)
        
        XCTAssertNotEqual(fullfillments.count, fullfillCount)
    }
    
    // PassThroughSubject test: send, completion, cancel
    func test_9() {
        // Given
        var integerSubject = PassThroughSubject<Int, Never>()
        var fullfillments = Set<Int>()
        let fullfillCount = 5
        
        cancellable = integerSubject
            .sink(receiveCompletion: { completion in
            }, receiveValue: { output in
                print(output)
            })
        
        // When
        integerSubject
            .send(3)
        
        integerSubject
            .send(5)
        
        cancellable?.cancel()
        
        cancellable = integerSubject
            .sink(receiveCompletion: { completion in
            }, receiveValue: { output in
                print(output)
            })
        
        integerSubject
            .send(9)
        
        integerSubject
            .send(19)

        integerSubject
            .send(completion: .finished)
        
        integerSubject
            .send(40)

        XCTAssertNotEqual(fullfillments.count, fullfillCount)
    }
    
    // Assign Subscriber
    func test_10() {
        class MyClass {
            var anInt: Int = 0 {
                didSet {
                    print("anInt was set to: \(anInt)", terminator: "; ")
                }
            }
        }
        
        var myObject = MyClass()
        let myRange = (0...2)
        
        cancellable = myRange.publisher
            .assign(to: \.anInt, on: myObject)
    }
    
    // Assign Cancel, Completion
    func test_11() {
        class MyClass {
            var anInt: Int = 0 {
                didSet {
                    print("anInt was set to: \(anInt)", terminator: "; ")
                }
            }
        }
        
        var myObject = MyClass()
        var intSubject = PassThroughSubject<Int, Never>()
        
        cancellable = intSubject
            .assign(to: \.anInt, on: myObject)
        
        intSubject.send(0)
        
        cancellable?.cancel()
        
        intSubject = PassThroughSubject<Int, Never>()
        
        cancellable = intSubject
            .assign(to: \.anInt, on: myObject)
        
        intSubject.send(1)
        
        intSubject.send(completion: .finished)
        
        intSubject.send(2)
        
        XCTAssertEqual(myObject.anInt, 1)
    }
    
    func test_12() {
        class TypeWithSubject {
            let publisher: some Publisher = PassThroughSubject<Int,Never>()
        }
        class TypeWithErasedSubject {
            let publisher: some Publisher = PassThroughSubject<Int,Never>()
                .eraseToAnyPublisher()
        }


        // In another module:
        let nonErased = TypeWithSubject()
        if let subject = nonErased.publisher as? PassThroughSubject<Int,Never> {
            print("Successfully cast nonErased.publisher.")
        }
        let erased = TypeWithErasedSubject()
        if let subject = erased.publisher as? PassThroughSubject<Int,Never> {
            print("Successfully cast erased.publisher.")
        } else if let subject = erased.publisher as? AnyPublisher<Int, Never> {
            print("Successfully cast erased.publisher.")
        }
    }
    
    // map() test
    func test_13() {
        let intSubject = PassThroughSubject<Int, Never>()
        
        cancellable = intSubject
            .map({ $0 < 350 })
            .sink(receiveValue: { output in
                print(output)
            })
        
        intSubject.send(200)
        intSubject.send(400)
        intSubject.send(completion: .finished)
        intSubject.send(599)
    }
}
