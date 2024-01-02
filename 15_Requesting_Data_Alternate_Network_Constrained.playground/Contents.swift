import Cocoa
import Combine

var greeting = "Hello, playground"

/// Requesting Data Alternate Network Constrained
///

struct PostmanEchoTimeStampCheckResponse: Hashable, Codable {
    let valid: Bool
}

enum MyNetworkingError: Error {
    case invalidServerResponse
}

let myURL = URL(string: "https://postman-echo.com/time/valid?timestamp=2016-10-10")!

/// Generalized Publisher for Adaptive URL Loading
///
func adaptiveLoader(regularURL: URL, lowDataURL: URL) -> AnyPublisher<Data, Error> {
    var request = URLRequest(url: regularURL) // 1
    request.allowsConstrainedNetworkAccess = false // 2
    
    return URLSession.shared.dataTaskPublisher(for: request) // 3
        .print()
        .tryCatch { error -> URLSession.DataTaskPublisher in // 4
            guard error.networkUnavailableReason == .constrained else {
                throw error
            }
            
            return URLSession.shared.dataTaskPublisher(for: lowDataURL) // 5
        }
        .tryMap { data, response -> Data in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw MyNetworkingError.invalidServerResponse
            }
            
            return data
        }
        .eraseToAnyPublisher()
}

/// Example usage
///
let subscriber = adaptiveLoader(
    regularURL: .init(string: "https://www.apple.com")!,
    lowDataURL: .init(string: "https://heckj.github.io/swiftui-notes/")!
).sink { completion in
    switch completion {
    case .finished:
        print(".sink() finished")
    case .failure(let error):
        print(".sink() failure with error: ", error.localizedDescription)
    }
} receiveValue: { someValue in
    print(".sink() receiveValue: ", someValue)
}

/// 1. The request starts with an attempt requesting data.
/// 2. Setting request.allowsConstrainedNetworkAccess will cause the dataTaskPublisher
///     to error if the network is constrained.
/// 3. Invoke the dataTaskPublisher to make the request.
/// 4. tryCatch is used to capture the immediate error condition and check
///     for a specific error (the constrained network).
/// 5. If it finds an error, it creates a new one-shot publisher with the fall-back URL.
/// 6. The resulting publisher can still fail, and tryMap can map this a failure 
///     by throwing an error on HTTP response codes that map to error conditions.
/// 7. eraseToAnyPublisher enables type erasure on the chain of operators
///     so the resulting signature of the adaptiveLoader function is AnyPublisher<Data, Error>.
///
