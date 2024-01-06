import Cocoa
import Combine
import XCTest

var greeting = "Hello, playground"

/// Subscriber Scheduled Sends PassthroughSubject
///

private final class KVOAbleNSObject: NSObject {
    @objc dynamic var intValue: Int = 0
    @objc dynamic var boolValue: Bool = false
}

final class SubscriberScheduledSendsPassthroughSubjectTests: XCTestCase {
    func testKVOPublisher() -> Void {
        let expectation = XCTestExpectation(description: self.debugDescription)
        let foo = KVOAbleNSObject()
        let q = DispatchQueue(label: self.debugDescription) // 1
        
        let _ = foo.publisher(for: \.intValue)
            .print()
            .sink { someValue in
                print("value of intValue updated to: >>\(someValue)<<")
            }
        
        q.asyncAfter(deadline: .now() + 5.0) { // 2
            print("Updating to foo.intValue on background queue")
            foo.intValue = 5
            expectation.fulfill() // 3
        }
        
        XCTWaiter.wait(for: [expectation], timeout: 5.0) // 4
    }
}

/// Example usages
///
SubscriberScheduledSendsPassthroughSubjectTests.defaultTestSuite.run()

/// 1. This adds a DispatchQueue to your test, naming the queue after the test itself. This really only shows when debugging test failures,
///     and is convenient as a reminder of what is happening in the test code vs. any other background queues that might be in use.
/// 2. .asyncAfter is used along with the deadline parameter to define when a call gets made.
/// 3. The simplest form embeds any relevant assertions into the subscriber or around the subscriber. Additionally, invoking the .fulfill()
///     on your expectation as the last queued entry you send lets the test know that it is now complete.
/// 4. Make sure that when you set up the wait that allow for sufficient time for your queue’d calls to be invoked.
///





/// An example of this from the EntwineTest project README is included:
///
//func testExampleUsingVirtualTimeScheduler() {
//    let scheduler = TestScheduler(initialClock: 0) // 1
//    var didSink = false
//    let cancellable = Just(1) // 2
//        .delay(for: 1, scheduler: scheduler)
//        .sink { _ in
//            didSink = true
//        }
//
//    XCTAssertNotNil(cancellable)
//    // Where a real scheduler would have triggered when .sink() was invoked
//    // the virtual time scheduler requires resume() to commence and runs to
//    // completion.
//    scheduler.resume() // 3
//    XCTAssertTrue(didSink) // 4
//}

/// 1. Using the virtual time scheduler requires you create one at the start of the test, initializing its clock to a starting value.
///     The virtual time scheduler in EntwineTest will commence subscription at the value 200 and times out at 900
///     if the pipeline isn’t complete by that time.
/// 2. You create your pipeline, along with any publishers or subscribers, as normal. EntwineTest also offers a testable publisher and
///     a testable subscriber that could be used as well. For more details on these parts of EntwineTest, see Using EntwineTest
///     to create a testable publisher and subscriber.
/// 3. .resume() needs to be invoked on the virtual time scheduler to commence its operation and run the pipeline.
/// 4. Assert against expected end results after the pipeline has run to completion.
///
