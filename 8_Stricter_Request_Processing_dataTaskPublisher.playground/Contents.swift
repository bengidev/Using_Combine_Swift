import Cocoa
import Combine

var greeting = "Hello, playground"

/// Stricter Request Processing With dataTaskPublisher
///

let myURL = URL(string: "https://postman-echo.com/time/valid?timestamp=2016-10-10")!
// checks the validity of a timestamp - this one returns {"valid":true}
// matching the data structure returned from https://postman-echo.com/time/valid

struct PostmanEchoTimeStampCheckResponse: Hashable, Codable {
    let valid: Bool
}

enum TestFailureCondition: Error {
    case invalidServerResponse
}

let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: myURL)
    .tryMap { data, response -> Data in // 1
        guard let httpResponse = response as? HTTPURLResponse, // 2
              httpResponse.statusCode == 200 else { // 3
            throw TestFailureCondition.invalidServerResponse // 4
        }
        
        return data // 5
    }
    .decode(type: PostmanEchoTimeStampCheckResponse.self, decoder: JSONDecoder())
    .eraseToAnyPublisher()

let cancellableSink = remoteDataPublisher
    .sink { completion in
        print(".sink() received the completion", String(describing: completion))
        
        switch completion {
        case .finished:
            print(".sink() finished the completion")
        case .failure(let error):
            print(".sink() failure the completion with error: \(error)")
        }
    } receiveValue: { someValue in
        print(".sink() received \(someValue)")
    }

/// 1. tryMap still gets the tuple of (data: Data, response: URLResponse), and is defined here
///     as returning just the type of Data down the pipeline.
/// 2. Within the closure for tryMap, we can cast the response to HTTPURLResponse and dig deeper into it,
///     including looking at the specific status code.
/// 3. In this case, we want to consider anything other than a 200 response code as a failure.
///     HTTPURLResponse.statusCode is an Int type, so you could also have logic such as httpResponse.statusCode > 300.
/// 4. If the predicates are not met it throws an instance of an error of our choosing; invalidServerResponse in this case.
/// 5. If no error has occurred, then we simply pass down Data for further processing.
///

