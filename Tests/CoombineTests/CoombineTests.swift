import XCTest
@testable import Coombine

final class CoombineTests: XCTestCase {
    func test_Publisher_and_subscriber() {
        // GIVEN
        Just(5)
            // WHEN
            .receive(subscriber:
                        Sink(receiveValue: { input in
                // THEN
                XCTAssertEqual(input, 5)
            }, receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finish")
                }
            })
            )
    }
    
    func test_Publisher_and_sink_func() {
        // GIVEN
        let cancellable = Just(5)
            // WHEN
            .sink { output in
                XCTAssertEqual(output, 5)
            }

        cancellable.cancel()
    }
}
