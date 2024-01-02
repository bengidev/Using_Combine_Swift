import Cocoa
import Combine

var greeting = "Hello, playground"

/// Using Catch Handle Errors
///

struct IPInfo: Codable {
    // Matching the data structure returned from ip.jsontest.com
    //
    var ip: String
}

let myURL = URL(string: "http://ip.jsontest.com")!
// NOTE(heckj): you'll need to enable insecure downloads in your Info.plist for this example
// since the URL scheme is 'http'
//

let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: myURL)
// The dataTaskPublisher output combination is (data: Data, response: URLResponse)
    .map { (inputTuple) -> Data in
        return inputTuple.data
    }
    .decode(type: IPInfo.self, decoder: JSONDecoder()) // 1
    .catch { error in // 2
        return Just(IPInfo(ip: "8.8.8.8")) // 3
    }
    .eraseToAnyPublisher()

/// Example usage
///
let subscriber = remoteDataPublisher.sink { completion in
    switch completion {
    case .finished:
        print(".sink() completion finished")
    }
} receiveValue: { someValue in
    print(".sink() receiveValue:", someValue)
}

/// 1. Often, a catch operator will be placed after several operators that could fail, in order to provide a fallback
///     or placeholder in the event that any of the possible previous operations failed.
/// 2. When using catch, you get the error type in and can inspect it to choose how you provide a response.
/// 3. The Just publisher is frequently used to either start another one-shot pipeline or to directly provide
///     a placeholder response in the event of failure.
///

