import Cocoa
import Combine

var greeting = "Hello, playground"

/// flatMap And catch Without Cancelling
///

struct PostmanEchoTimeStampCheckResponse: Hashable, Codable {
    let valid: Bool
}

enum TestFailureCondition: Error {
    case invalidServerResponse
}

let myURL = URL(string: "https://postman-echo.com/time/valid?timestamp=2016-10-10")!

let remoteDataPublisher = Just(myURL) // 1
    .flatMap { url in // 2
        URLSession.shared.dataTaskPublisher(for: url) // 3
            .tryMap { data, response -> Data in // 4
                guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    throw TestFailureCondition.invalidServerResponse
                }
                
                return data
            }
            .decode(type: PostmanEchoTimeStampCheckResponse.self, decoder: JSONDecoder()) // 5
            .catch { _ in // 6
                return Just(PostmanEchoTimeStampCheckResponse(valid: false))
            }
    }
    .print()
    .eraseToAnyPublisher()

/// Example usage
///
let subscriber = remoteDataPublisher.sink { completion in
    switch completion {
    case .finished:
        print(".sink() finished")
    case .failure(let error):
        print(".sink() failure with error: ", error.localizedDescription)
    }
} receiveValue: { someValue in
    print(".sink() receiveValue: ", someValue)
}

/// 1. Just starts this publisher as an example by passing in a URL.
/// 2. flatMap takes the URL as input and the closure goes on to create
///     a one-shot publisher pipeline.
/// 3. dataTaskPublisher uses the input url to make the request.
/// 4. The result output ( a tuple of (Data, URLResponse) ) flows into tryMap
///     to be parsed for additional errors.
/// 5. decode attempts to refine the returned data into a locally defined type.
/// 6. If any of this has failed, catch will convert the error into a placeholder sample.
///     In this case an object with a preset valid = false property.
///
