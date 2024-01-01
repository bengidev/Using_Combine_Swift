import Cocoa
import Combine

var greeting = "Hello, playground"

// Ilustrate Exposed Type Complexity
//
let x = PassthroughSubject<String, Never>()
    .flatMap { name in
        return Future<String, Error> { promise in
            print("Promise: \(String(describing: promise))")
            
            promise(.success("Success"))
        }
        .catch { _ in
            Just("No user found")
        }
        .map { result in
            print("Result: \(String(describing: result))")
            
            return "\(result) foo"
        }
    }

/// The resulting type is:
/// Publishers.FlatMap<Publishers.Map<Publishers.Catch<Future<String, Error>, Just<String>>, String>, PassthroughSubject<String, Never>>
///

/// If you updated the above code to add .eraseToAnyPublisher() at the end of the pipeline
///
let y = PassthroughSubject<String, Never>()
    .flatMap { name in
        return Future<String, Error> { promise in
            print("Promise: \(String(describing: promise))")
            
            promise(.success("Success"))
        }
        .catch { _ in
            Just("No user found")
        }
        .map { result in
            print("Result: \(String(describing: result))")
            
            return "\(result) foo"
        }
    }
    .eraseToAnyPublisher()

/// The resulting type would simplify to:
/// AnyPublisher<String, Never>
///

