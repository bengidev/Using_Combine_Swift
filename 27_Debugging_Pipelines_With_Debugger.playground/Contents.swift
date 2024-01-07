import Cocoa
import Combine
import XCTest

var greeting = "Hello, playground"

/// Debugging Pipelines With Debugger
///

final class DebuggingPipelinesWithDebuggerTests: XCTestCase {
    var cancellableSet: Set<AnyCancellable> = []
    
    func testDebuggingPipelinesWithDebugger() async -> Void {
        let stringURL: URL = .init(string: "https://api.github.com/users/bengidev")!
        var validData: Data = .init()
        var validDataExpectation: XCTestExpectation = .init(description: "validData should not be empty or zero")
        
        let publisher = URLSession.shared.dataTaskPublisher(for: stringURL)
            .print()
            .delay(for: 5, scheduler: DispatchQueue.global())
            .map { data, response -> Data in
                if let responseCode = response as? HTTPURLResponse,
                   responseCode.statusCode == 200 {
                    return data
                }
                
                return .init()
            }
            .breakpoint { subscription in
                print(".breakpoint() subscription: ", String(describing: subscription))
                return false // return true to throw SIGTRAP and invoke the debugger
            } receiveOutput: { output in
                print(".breakpoint() receiveOutput: ", String(describing: output))
                return false // return true to throw SIGTRAP and invoke the debugger
            } receiveCompletion: { completion in
                print(".breakpoint() receiveCompletion: ", String(describing: completion))
                return false // return true to throw SIGTRAP and invoke the debugger
            }
        
        let _ = publisher
            .sink { completion in
                print(".sink() receiveCompletion: ", String(describing: completion))
            } receiveValue: { value in
                if !value.isEmpty {
                    validData = value
                    validDataExpectation.fulfill()
                    print(".sink() validData: ", String(describing: validData))
                }
                
                XCTAssertNotNil(validData)
                XCTAssertNotEqual(validData, Data.init())
                
                print(".sink() receiveValue: ", String(describing: value))
            }
            .store(in: &cancellableSet)

        await fulfillment(of: [validDataExpectation])
    }
}

/// Example usages
///
DebuggingPipelinesWithDebuggerTests.defaultTestSuite.run()

/// If you are only interested in the breaking into the debugger on error conditions,
/// then convenience operator breakPointOnError is perfect. It takes no parameters or closures,
/// simply invoking the debugger when an error condition of any form is passed through the pipeline.
///
/// .breakpointOnError()
///
