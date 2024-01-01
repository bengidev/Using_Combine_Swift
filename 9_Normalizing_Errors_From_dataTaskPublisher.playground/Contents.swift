import Cocoa
import Combine

var greeting = "Hello, playground"

/// Normalizing Errors From dataTaskPublisher
///

enum TestExampleError: Error { }

enum APIError: Error, LocalizedError { // 1
    case apiError(reason: String)
    case parserError(reason: String)
    case networkError(from: URLError)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .apiError(let reason):
            return reason
        case .parserError(let reason):
            return reason
        case .networkError(let from): // 2
            return from.localizedDescription
        case .unknown:
            return "Unknown error"
        }
    }
}

func fetchData(with url: URL) -> AnyPublisher<Data, APIError> {
    let request = URLRequest(url: url)
    
    let urlPublisher = URLSession.DataTaskPublisher(request: request, session: .shared) // 3
        .tryMap { data, response in // 4
            guard let httpResponse = response as? HTTPURLResponse else { throw APIError.unknown}
            
            if (httpResponse.statusCode == 401) {
                throw APIError.apiError(reason: "Unauthorized");
            }
            if (httpResponse.statusCode == 403) {
                throw APIError.apiError(reason: "Resource forbidden");
            }
            if (httpResponse.statusCode == 404) {
                throw APIError.apiError(reason: "Resource not found");
            }
            if (405..<500 ~= httpResponse.statusCode) {
                throw APIError.apiError(reason: "client error");
            }
            if (500..<600 ~= httpResponse.statusCode) {
                throw APIError.apiError(reason: "server error");
            }
            return data
        }
        .mapError { error in // 5
            // if it's our kind of error already, we can return it directly
            if let error = error as? APIError {
                return error
            }
            // if it is a TestExampleError, convert it into our new error type
            if error is TestExampleError {
                return APIError.parserError(reason: "Our test example error")
            }
            // if it is a URLError, we can convert it into our more general error kind
            if let urlerror = error as? URLError {
                return APIError.networkError(from: urlerror)
            }
            // if all else fails, return the unknown error condition
            return APIError.unknown
        }
        .eraseToAnyPublisher() // 6
    
    return urlPublisher
}

let publisher = fetchData(with: .init(string: "https://jsonplaceholder.typicode.com/posts")!)

let subscriber = publisher
    .map {
        print("Bytes Data: \($0)")
        return String($0.description)
    }
    .sink { completion in
        switch completion {
        case .finished:
            print(".sink() finished")
        case .failure(let error):
            print(".sink() error: \(error)")
        }
    } receiveValue: { someValue in
        print(".sink() receiveValue: \(someValue)")
    }

/// 1. APIError is a Error enumeration that we are using in this example to collect 
///     all the variant errors that can occur.
/// 2. .networkError is one of the specific cases of APIError that we will translate
///     into when URLSession.dataTaskPublisher returns an error.
/// 3. We start the generation of this publisher with a standard dataTaskPublisher.
/// 4. We then route into the tryMap operator to inspect the response, creating specific error
///     conditions based on the server response.
/// 5. And finally we use mapError to convert any lingering error types down into a common Failure type of APIError.
///
