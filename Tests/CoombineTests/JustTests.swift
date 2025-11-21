//
//  JustTests.swift
//  Coombine
//
//  Created by 테스트 on 11/21/25.
//

import Testing
import Combine
@testable import Coombine

struct JustTests {
    
    @Suite("Combine")
    struct Combine {
        @Test("Just publisher basic test from `Combine`")
        func testJust001() async throws {
            // Given
            let pub1 = Just(0)
            
            let sub1 = Subscribers.Sink<Int, Never>(receiveCompletion: { comp in
                print("🔵 sub1 - completion", comp)
            }, receiveValue: { code in
                // Then
                print("🔵 sub1 - value", code)
                #expect(code == 0)
            })
            
            print("🟢 sub1's id", "\(sub1.combineIdentifier)")
            
            // When
            pub1
                .print("🟡 test 001")
                .receive(subscriber: sub1)
        }
        
        @Test("Test Just behaviour - various subscribers")
        func testJust002() async throws {
            // Given
            var fulfill = 0
            let pub = Just(0)
            
            let sub1 = Subscribers.Sink<Int, Never>(receiveCompletion: { comp in
                print("🔵 sub1 - completion", comp)
            }, receiveValue: { code in
                // Then
                fulfill += 1
            })
            
            let sub2 = Subscribers.Sink<Int, Never>(receiveCompletion: { comp in
                print("🔵 sub2 - completion", comp)
            }, receiveValue: { code in
                // Then
                fulfill += 1
            })
            
            print("🟢 sub1's id", "\(sub1.combineIdentifier)")
            print("🟢 sub2's id", "\(sub2.combineIdentifier)")
            
            // When
            pub
                .print("🟡 test 002 - sub1")
                .receive(subscriber: sub1)
            pub
                .print("🟡 test 002 - sub2")
                .receive(subscriber: sub2)
            
            try await Task.sleep(for: .seconds(1))
            #expect(fulfill == 2)
            
        }
        
        @Test("Test Just behaviour - subscribed multiple times to same subscriber")
        func testJust003() async throws {
            // Given
            var fulfill = 0
            let pub = Just(0)
            
            let sub1 = Subscribers.Sink<Int, Never>(receiveCompletion: { comp in
                print("🔵 sub1 - completion", comp)
            }, receiveValue: { code in
                // Then
                fulfill += 1
            })
            
            print("🟢 sub1's id", "\(sub1.combineIdentifier)")
            
            // When
            pub
                .print("🟡 test 003 - sub1 - 1")
                .receive(subscriber: sub1)
            pub
                .print("🟡 test 003 - sub1 - 2")
                .receive(subscriber: sub1)
            #expect(fulfill == 1)
        }
    }
    
    @Suite("Combine")
    struct Coombine {
        @Test("Just publisher basic test from `Coombine`")
        func testJust001() async throws {
            // Given
            let pub1 = _Just(0)
            
            let sub1 = _Subscribers._Sink<Int, Never>(receiveCompletion: { comp in
                print("🔵 sub1 - completion", comp)
            }, receiveValue: { code in
                // Then
                print("🔵 sub1 - value", code)
                #expect(code == 0)
            })
            // When
            pub1
                .print("🟡 test 001")
                .receive(subscriber: sub1)
        }
        
        @Test("Test Just behaviour - various subscribers")
        func testJust002() async throws {
            // Given
            var fulfill = 0
            let pub = _Just(0)
            
            let sub1 = _Subscribers._Sink<Int, Never>(receiveCompletion: { comp in
                print("🔵 sub1 - completion", comp)
            }, receiveValue: { code in
                // Then
                fulfill += 1
            })
            
            let sub2 = _Subscribers._Sink<Int, Never>(receiveCompletion: { comp in
                print("🔵 sub2 - completion", comp)
            }, receiveValue: { code in
                // Then
                fulfill += 1
            })
            
            // When
            pub
                .print("🟡 test 002 - sub1")
                .receive(subscriber: sub1)
            pub
                .print("🟡 test 002 - sub2")
                .receive(subscriber: sub2)
            
            try await Task.sleep(for: .seconds(1))
            #expect(fulfill == 2)
            
        }
        
        @Test("Test Just behaviour - subscribed multiple times to same subscriber")
        func testJust003() async throws {
            // Given
            var fulfill = 0
            let pub = _Just(0)
            
            let sub1 = _Subscribers._Sink<Int, Never>(receiveCompletion: { comp in
                print("🔵 sub1 - completion", comp)
            }, receiveValue: { code in
                // Then
                fulfill += 1
            })
            
            // When
            pub
                .print("🟡 test 003 - sub1 - 1")
                .receive(subscriber: sub1)
            pub
                .print("🟡 test 003 - sub1 - 2")
                .receive(subscriber: sub1)
            #expect(fulfill == 1)
        }
    }
}
