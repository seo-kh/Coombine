//
//  PrintTests.swift
//  
//
//  Created by alphacircle on 10/23/24.
//

import XCTest
@testable import Coombine

final class PrintTests: XCTestCase {
    var cancellalbe: Cancellable?
    
    override func tearDown() {
        cancellalbe?.cancel()
        cancellalbe = nil
    }

    func test1() {
        cancellalbe = (0..<10)
            .publisher
            .print()
            .sink(receiveValue: { output in print("output: \(output)") })
    }
    
    func test2() {
        let int = PassThroughSubject<Int, Never>()
        
        cancellalbe = int
            .print()
            .sink(receiveValue: { print("output:", $0)})
        
        int.send(0)
        int.send(2)
        cancellalbe?.cancel()
        int.send(5)
        int.send(8)
        int.send(completion: .finished)
        int.send(9)
        int.send(8)
    }

}
