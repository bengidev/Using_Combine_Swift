import Cocoa
import Combine
import XCTest

var greeting = "Hello, playground"

/// Debugging Pipelines Print Operator
///

enum TestFailureCondition: Error {
    case invalidServerResponse
}

private class DebuggingPipelinesPrintOperatorTests: XCTestCase {
    func testRetryWithOneShotFailPublisher() -> Void {
        // Setup
        //
        let cancellable = Fail(
            outputType: String.self,
            failure: TestFailureCondition.invalidServerResponse
        )
            .print("(1)>)") // 1
            .retry(3)
            .print("(2)>") // 2
            .sink { completion in
                print(" ** .sink() received the completion:", String(describing: completion))
            } receiveValue: { value in
                XCTAssertNotNil(value)
                print(" ** .sink() received \(value)")
            }
        XCTAssertNotNil(cancellable)
    }
}

/// Example usages
///
DebuggingPipelinesPrintOperatorTests.defaultTestSuite.run()

/// 1. In the test sample, the publisher always reports a failure, resulting in seeing the prefix (1) receiving the error,
///     and then the resubscription from the retry operator.
/// 2. And after 4 of those attempts (3 "retries"), then you see the error falling through the pipeline.
///     After the error hits the sink, you see the cancel signal propagated back up, which stops at the retry operator.
///

