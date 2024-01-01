import Cocoa

var greeting = "Hello, playground"

/// Making Network Request With dataTaskPublisher
///

let myURL = URL(string: "https://postman-echo.com/time/valid?timestamp=2016-10-10")!
// checks the validity of a timestamp - this one returns {"valid":true}
// matching the data structure returned from https://postman-echo.com/time/valid

struct PostmanEchoTimeStampCheckResponse: Hashable, Codable { // 1
    let valid: Bool
}

let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: myURL) // 2
// The dataTaskPublisher output combination is (data: Data, response: URLResponse)
    .map { $0.data } // 3
    .decode(type: PostmanEchoTimeStampCheckResponse.self, decoder: JSONDecoder()) // 4

let cancellableSink = remoteDataPublisher
    .eraseToAnyPublisher()
    .sink { completion in
        print(".sink() received the completion", String(describing: completion))
        
        switch completion {
        case .finished: // 5
            print("remoteDataPublisher finished")
        case .failure(let error): // 6
            print("remoteDataPublisher error: \(error)")
        }
    } receiveValue: { someValue in // 7
        print(".sink() received \(someValue)")
    }

/// 1. Commonly you will have a struct defined that supports at least Decodable (if not the full Codable protocol).
///     This struct can be defined to only pull the pieces you are interested in from the JSON provided over the network.
///     The complete JSON payload does not need to be defined.
/// 2. dataTaskPublisher is instantiated from URLSession. You can configure your own options on URLSession, or use a shared session.
/// 3. The data that is returned is a tuple: (data: Data, response: URLResponse). The map operator is used to get
///     the data and drops the URLResponse, returning just Data down the pipeline.
/// 4. decode is used to load the data and attempt to parse it. Decode can throw an error itself if the decode fails.
///     If it succeeds, the object passed down the pipeline will be the struct from the JSON data.
/// 5. If the decoding completed without errors, the finished completion will be triggered and
///     the value will be passed to the receiveValue closure.
/// 6. If the a failure happens (either with the original network request or the decoding),
///     the error will be passed into with the failure closure.
/// 7. Only if the data succeeded with request and decoding will this closure get invoked, and the data format received will be
///     an instance of the struct PostmanEchoTimeStampCheckResponse.
///
