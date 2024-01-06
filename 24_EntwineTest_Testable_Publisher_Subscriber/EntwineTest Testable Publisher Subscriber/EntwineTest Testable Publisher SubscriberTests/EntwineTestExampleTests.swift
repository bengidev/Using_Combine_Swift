//
//  EntwineTestExampleTests.swift
//  EntwineTest Testable Publisher SubscriberTests
//
//  Created by Bambang Tri Rahmat Doni on 06/01/24.
//

import EntwineTest
import XCTest

final class EntwineTestExampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testMap() -> Void {
        let testScheduler = TestScheduler(initialClock: 0)
        
        // Creates a publisher that will schedule its elements relatively
        // at the point of subscription.
        //
        let testablePublisher: TestablePublisher<String, Never> = testScheduler
            .createRelativeTestablePublisher([ // 1
                (100, .input("a")),
                (200, .input("b")),
                (300, .input("c")),
        ])
        
        // A publisher that maps strings to uppercase
        //
        let subjectUnderTest = testablePublisher.map { $0.uppercased() }
        
        // Uses the method described above (schedules a subscription at 200
        // to be cancelled at 900).
        //
        let results = testScheduler.start { subjectUnderTest } // 2
        
        XCTAssertEqual(results.recordedOutput, [ // 3
            // Subscribed at 200
            //
            (200, .subscription),
            // Received uppercased input @ 100 + subscription time
            //
            (300, .input("A")),
            // Received uppercased input @ 200 + subscription time
            //
            (400, .input("B")),
            // Received uppercased input @ 300 + subscription time
            //
            (500, .input("C")),
        ])
    }
}

/// 1. The TestablePublisher lets you set up a publisher that returns specific values at specific times.
///     In this case, it’s returning 3 items at consistent intervals.
/// 2. When you use the virtual time scheduler, it is important to make sure to invoke it with start.
///     This runs the virtual time scheduler, which can run faster than a clock since it only needs
///     to increment the virtual time and not wait for elapsed time.
/// 3. results is a TestableSubscriber object, and includes a recordedOutput property which provides 
///     an ordered list of all the data and combine control path interactions with their timing.
///

