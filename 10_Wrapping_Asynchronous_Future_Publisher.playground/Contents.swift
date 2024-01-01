import Cocoa
import Combine
import Contacts

var greeting = "Hello, playground"

/// Wrapping Asynchronous Future Publisher
///

let futureAsyncPublisher = Future<Bool, Error> { promise in // 1
    CNContactStore().requestAccess(for: .contacts) { granted, error in // 2
        // Error is an optional
        if let error { return promise(.failure(error)) } // 3
        
        return promise(.success(granted)) // 4
    }
}.eraseToAnyPublisher()

/// Example usage
///
futureAsyncPublisher.sink { completion in
    switch completion {
    case .finished:
        print("futureAsyncPublisher .sink() finished")
    case .failure(let error):
        print("futureAsyncPublisher .sink() failure with error: \(error)")
    }
} receiveValue: { someValue in
    print("futureAsyncPublisher .sink() receiveValue: \(someValue)")
}

/// 1. Future itself has you define the return types and takes a closure. It hands in
///     a Result object matching the type description, which you interact
/// 2. You can invoke the async API however is relevant, including passing in its required closure.
/// 3. Within the completion handler, you determine what would cause a failure or a success.
///     A call to promise(.failure(<FailureType>)) returns the failure.
/// 4. Or a call to promise(.success(<OutputType>)) returns a value.
///





/// The following example returns a single value as a success, with a boolean true value.
/// You could just as easily return false, and the publisher would still act as a successful promise.
///
let resolvedSuccessAsPublisher = Future<Bool, Error> { promise in
    promise(.success(true))
}.eraseToAnyPublisher()

/// Example usage
///
resolvedSuccessAsPublisher.sink { completion in
    switch completion {
    case .finished:
        print("resolvedSuccessAsPublisher .sink() finished")
    case .failure(let error):
        print("resolvedSuccessAsPublisher .sink() failure with error: \(error)")
    }
} receiveValue: { someValue in
    print("resolvedSuccessAsPublisher .sink() receiveValue: \(someValue)")
}




/// An example of returning a Future publisher that immediately resolves as an error:
///
enum ExampleFailure: Error {
    case oneCase
}

let resolvedFailureAsPublisher = Future<Bool, Error> { promise in
    promise(.failure(ExampleFailure.oneCase))
}.eraseToAnyPublisher()

/// Example usage
///
resolvedFailureAsPublisher.sink { completion in
    switch completion {
    case .finished:
        print("resolvedFailureAsPublisher .sink() finished")
    case .failure(let error):
        print("resolvedFailureAsPublisher .sink() failure with error: \(error)")
    }
} receiveValue: { someValue in
    print("resolvedFailureAsPublisher .sink() receiveValue: \(someValue)")
}

