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

    @Test("Just publisher basic test from `Combine` and `Coombine`")
    func testJust001() async throws {
        // Given
        let pub1 = Just(0)
        let pub2 = _Just(1)
        
        let sub1 = Subscribers.Sink<Int, Never>(receiveCompletion: {_ in}, receiveValue: { code in
            // Then
            print("pub1", code)
             #expect(code == 0)
        })
        let sub2 = _Subscribers._Sink<Int, Never>(receiveCompletion: {_ in}, receiveValue: { code in
            // Then
            print("pub2", code)
            #expect(code == 1)
        })

        // When
        pub1.receive(subscriber: sub1)
        pub2.receive(subscriber: sub2)
        
        // try await Task.sleep(for: .seconds(2))
    }

}
