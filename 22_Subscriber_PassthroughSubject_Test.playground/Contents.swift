import Cocoa
import Combine
import XCTest

var greeting = "Hello, playground"

/// Subscriber PassthroughSubject Test
///

enum TestFailureCondition: Error {
    case anErrorExample
}

final class SubscriberPassthroughSubjectTests: XCTestCase {
    func testSinkReceiveDataThenError() -> Void {
        // Setup - Preconditions // 1
        //
        var countValuesReceived = 0
        var countCompletionsReceived = 0
        
        let expectedValues = ["firstStringValue", "secondStringValue"]
    
        // Setup
        //
        let simplePublisher = PassthroughSubject<String, Error>() // 2
        
        var cancellableSet: Set<AnyCancellable> = []
        
        simplePublisher // 3
            .sink { completion in
                countCompletionsReceived += 1
                
                switch completion {
                case .finished:
                    print(".sink() received the completion:", String(describing: completion))
                    // No associated data, but you can react to knowing the request has been completed
                    //
                    XCTFail("We should never receive the completion, the error should happen first")
                case .failure(let error):
                    // Do what you want with the error details, presenting, logging, or hiding as appropriate
                    //
                    print(".sink() received the error: ", error)
                    XCTAssertEqual(
                        error.localizedDescription,
                        TestFailureCondition.anErrorExample.localizedDescription // 5
                    )
                }
            } receiveValue: { someValue in // 6
                // Do what you want with the resulting value passed down.
                // Be aware that depending on the data type being returned,
                // you may get this closure invoked multiple times.
                //
                XCTAssertNotNil(someValue)
                XCTAssertTrue(expectedValues.contains(someValue))
                countValuesReceived += 1
                print(".sink() received \(someValue)")
            }
            .store(in: &cancellableSet)
        
        // Validate
        //
        XCTAssertEqual(countValuesReceived, 0) // 7
        XCTAssertEqual(countCompletionsReceived, 0) // 7
        
        simplePublisher.send("firstStringValue") // 8
        XCTAssertEqual(countValuesReceived, 1)
        XCTAssertEqual(countCompletionsReceived, 0)
        
        simplePublisher.send("secondStringValue")
        XCTAssertEqual(countValuesReceived, 2)
        XCTAssertEqual(countCompletionsReceived, 0)
        
        simplePublisher.send(completion: .failure(TestFailureCondition.anErrorExample)) // 9
        XCTAssertEqual(countValuesReceived, 2)
        XCTAssertEqual(countCompletionsReceived, 1)
        
        // This data will never be seen by anything in the pipeline above because
        // we have already sent a completion.
        //
        simplePublisher.send(completion: .finished) // 10
        XCTAssertEqual(countValuesReceived, 2)
        XCTAssertEqual(countCompletionsReceived, 1)
    }
}

/// 1. This test sets up some variables to capture and modify during test execution that we use to validate when and how the sink code operates.
///     Additionally, we have an error defined here because it’s not coming from other code elsewhere.
/// 2. The setup for this code uses the passthroughSubject to drive the test, but the code we are interested in testing is the subscriber.
/// 3. The subscriber setup under test (in this case, a standard sink). We have code paths that trigger on receiving data and completions.
/// 4. Within the completion path, we switch on the type of completion, adding an assertion that will fail the test if a finish is called,
///     as we expect to only generate a .failure completion.
/// 5. Testing error equality in Swift can be awkward, but if the error is code you are controlling, you can sometimes use the localizedDescription
///     as a convenient way to test the type of error received.
/// 6. The receiveValue closure is more complex in how it asserts against received values. Since we are receiving multiple values in the process
///     of this test, we have some additional logic to check that the values are within the set that we send. Like the completion handler,
///     We also increment test specific variables that we will assert on later to validate state and order of operation.
/// 7. The count variables are validated as preconditions before we send any data to double check our assumptions.
/// 8. In the test, the send() triggers the actions, and immediately after we can test the side effects through the test variables we are updating.
///     In your own code, you may not be able to (or want to) modify your subscriber, but you may be able to provide private/testable properties or windows
///     into the objects to validate them in a similar fashion.
/// 9. We also use send() to trigger a completion, in this case a failure completion.
/// 10. And the final send() is validating the operation of the failure that just happened - that it was not processed, and no further state updates happened.
///

/// Example tests
///
SubscriberPassthroughSubjectTests.defaultTestSuite.run()

