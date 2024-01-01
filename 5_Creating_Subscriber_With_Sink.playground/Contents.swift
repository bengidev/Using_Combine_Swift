import Cocoa
import Combine

var greeting = "Hello, playground"

///5_Creating_Subscriber_With_Sink
///
let publishingSource = PassthroughSubject<String, Never>()

/// Simple sink
///
let cancellablePipeline = publishingSource.sink { someValue in // 1
    // do what you want with the resulting value passed down
    // be aware that depending on the publisher, this closure
    // may be invoked multiple times.
    print(".sink() received \(someValue)")
}

for i in 0..<10 {
    Thread.sleep(forTimeInterval: 1.0)
    publishingSource.send("Number: \(i)")
}

/// 1. The simple version of a sink is very compact, with a single trailing closure
/// receiving data when presented through the pipeline.
///





/// Sink with completions and data
///
let publishingSourceTwo = PassthroughSubject<String, Never>()

/// Simple sink
///
let cancellablePipelineTwo = publishingSourceTwo.sink { completion in // 1
    switch completion {
    case .finished:
        // no associated data, but you can react to knowing the
        // request has been completed
        print("publishingSourceTwo Finished")
        break
    case .failure(let error):
        // do what you want with the error details, presenting,
        // logging, or hiding as appropriate
        print("publishingSourceTwo Error: \(error)")
        break
    }
} receiveValue: { value in
    // do what you want with the resulting value passed down
    // be aware that depending on the publisher, this closure
    // may be invoked multiple times.
    print(".sink() received \(value)")
}

for i in 0..<10 {
    Thread.sleep(forTimeInterval: 1.0)
    publishingSourceTwo.send("Number: \(i)")
    
    if i == 5 {
        publishingSourceTwo.send(completion: .finished)
    }
}

cancellablePipelineTwo.cancel() // 2

/// 1. Sinks are created by chaining the code from a publisher or pipeline, and provide an end point for the pipeline.
/// When the sink is created or invoked on a publisher, it implicitly starts the lifecycle with the subscribe method, 
/// requesting unlimited data.
///
/// 2. Sinks are cancellable subscribers. At any time you can take the reference that terminated with sink and
/// invoke .cancel() on it to invalidate and shut down the pipeline.
///
