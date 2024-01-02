import Cocoa

var greeting = "Hello, playground"

/// Retrying in the Event of a Temporary Failure
///

struct PostmanEchoTimeStampCheckResponse: Hashable, Codable {
    let valid: Bool
}

enum TestFailureCondition: Error {
    case invalidServerResponse
}

let myURL = URL(string: "https://postman-echo.com/time/valid?timestamp=2016-10-10")!

let remoteDataPublisher = URLSession.shared.dataTaskPublisher(for: myURL)
    .print()
    .delay(for: DispatchQueue.SchedulerTimeType.Stride(integerLiteral: Int.random(in: 1 ..< 5)), scheduler: DispatchQueue.global(qos: .background)) // 1
    .retry(3) // 2
    .tryMap { data, response -> Data in // 3
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TestFailureCondition.invalidServerResponse
        }
        
        return data
    }
    .decode(type: PostmanEchoTimeStampCheckResponse.self, decoder: JSONDecoder())
    .subscribe(on: DispatchQueue.global(qos: .background))
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

/// 1. The delay operator will hold the results flowing through the pipeline for a short duration,
///      in this case for a random selection of 1 to 5 seconds. By adding delay here
///      in the pipeline, it will always occur, even if the original request is successful.
/// 2. Retry is specified as trying 3 times. This will result in a total of four attempts
///      if each fails - the original request and 3 additional attempts.
/// 3. tryMap is being used to inspect the data result from dataTaskPublisher and return
///     a .failure completion if the response from the server is valid,
///     but not a 200 HTTP response code.
///
