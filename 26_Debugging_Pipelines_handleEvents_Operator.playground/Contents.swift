import Cocoa
import Combine
import XCTest

var greeting = "Hello, playground"

/// Debugging Pipelines handleEvents Operator
///

final class DebuggingPipelinesHandleEventsOperatorTests: XCTestCase {
    var cancellableSet: Set<AnyCancellable> = []
    
    func testDebuggingPipelinesHandleEventsOperator() -> Void {
        let stringURL: URL = .init(string: "https://api.github.com/users/bengidev")!
        
        let publisher = URLSession.shared.dataTaskPublisher(for: stringURL)
            .print()
            .debounce(for: 5, scheduler: DispatchQueue.global())
            .retry(3)
            .delay(for: 3, scheduler: DispatchQueue.global())
            .handleEvents { subscription in // 2
                print("receiveSubscription event called with \(String(describing: subscription))")
            } receiveOutput: { value in // 3
                print("receiveOutput was invoked with \(String(describing: value))")
            } receiveCompletion: { completion in // 4
                print("receiveCompletion event called with \(String(describing: completion))")
            } receiveCancel: { // 5
                print("receiveCancel event invoked")
            } receiveRequest: { request in // 1
                print("receiveRequest event called with \(String(describing: request))")
            }
            .eraseToAnyPublisher()

        let _ = publisher
            .sink { completion in
                print(".sink() receive completion: ", String(describing: completion))
            } receiveValue: { value in
                print(".sink() receiveValue: ", String(describing: value))
            }
            .store(in: &cancellableSet)

        XCTAssertNotNil(stringURL)
        XCTAssertNoThrow(publisher)
    }
}

/// Example usages
///
DebuggingPipelinesHandleEventsOperatorTests.defaultTestSuite.run()

/// 1. The first closure called is receiveRequest, which will have the demand value passed into it.
/// 2. The second closure receiveSubscription is commonly the returning subscription from the publisher,
///     which passes in a reference to the publisher. At this point, the pipeline is operational,
///     and the publisher will provide data based on the amount of data requested in the original request.
/// 3. This data is passed into receiveOutput as the publisher makes it available, invoking the closure for each value passed.
///     This will repeat for as many values as the publisher sends.
/// 4. If the pipeline is closed - either normally or terminated due to a failure - the receiveCompletion closure will get the completion.
///     Just the like the sink closure, you can switch on the completion provided, and if it is a .failure completion,
///     then you can inspect the enclosed error.
/// 5. If the pipeline is cancelled, then the receiveCancel closure will be called. No data is passed into the cancellation closure.
///
