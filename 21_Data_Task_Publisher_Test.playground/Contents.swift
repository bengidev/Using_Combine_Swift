import Cocoa
import XCTest

var greeting = "Hello, playground"

/// Data Task Publisher Test
///

final class DataTaskPublisherTests: XCTestCase {
    func testDataTaskPublisher() -> Void {
        // Setup
        //
        let inputURL: URL = .init(string: "https://api.github.com/users/bengidev")!
        let expectation = XCTestExpectation(description: "Download from \(String(describing: inputURL))") // 1
        
        // Validate
        //
        let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: inputURL)
            .sink { completion in
                print(".sink() received the completion", String(describing: completion))
                
                switch completion {
                case .finished:
                    expectation.fulfill() // 2
                case .failure(_):
                    XCTFail() // 3
                }
            } receiveValue: { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    XCTFail("Unable to parse response an HTTPURLResponse")
                    return
                }
                
                XCTAssertNotNil(data)
                print(".sink() data received \(data)")
                
                XCTAssertNotNil(httpResponse)
                XCTAssertEqual(httpResponse.statusCode, 200) // 4
                print(".sink() httpResponse received \(httpResponse)")
            }
        
        XCTAssertNotNil(remoteDataPublisher)
        XCTWaiter.wait(for: [expectation], timeout: 5.0) // 5
    }
}

/// Example tests
///
DataTaskPublisherTests.defaultTestSuite.run()

/// 1. The expectation is set up with a string that makes debugging in the event of failure a bit easier.
///     This string is really only seen when a test failure occurs. The code we are testing here is dataTaskPublisher
///     retrieving data from a preset test URL, defined earlier in the test. The publisher is invoked by attaching
///     the sink subscriber to it. Without the expectation, the code will still run, but the test running structure
///     wouldn’t wait to see if there were any exceptions. The expectation within the test "holds the test" waiting
///     for a response to let the operators do their work.
/// 2. In this case, the test is expected to complete successfully and terminate normally, therefore the expectation.fulfill()
///     invocation is set within the receiveCompletion closure, specifically linked to a received .finished completion.
/// 3. Since we don’t expect a failure, we also have an explicit XCTFail() invocation if we receive a .failure completion.
/// 4. We have a few additional assertions within the receiveValue. Since this publisher set returns a single value and then terminates,
///     we can make inline assertions about the data received. If we received multiple values, then we could collect those and
///     make assertions on what was received after the fact.
/// 5. This test uses a single expectation, but you can include multiple independent expectations to require fulfillment.
///     It also sets that maximum time that this test can run to five seconds. The test will not always take five seconds,
///     as it will complete the test as soon as the fulfill is received. If for some reason the test takes longer than five seconds
///     to respond, the XCTest will report a test failure.
///

