//
//  GithubAPI.swift
//  GitHub Combine UIKit
//
//  Created by Bambang Tri Rahmat Doni on 03/01/24.
//

import Combine
import Foundation

enum APIFailureCondition: Error {
    case invalidServerResponse
}

final class GithubAPI: NSObject {
    /// Externally accessible publsher that indicates that network activity is happening in the API proxy
    ///
    static let networkActivityPublisher = PassthroughSubject<Bool, Never>()
    
    /// Creates a one-shot publisher that provides a GithubAPI User
    /// object as the end result. This method was specifically designed to
    /// return a list of 1 object, as opposed to the object itself to make
    /// it easier to distinguish a "no user" result (empty list)
    /// representation that could be dealt with more easily in a Combine
    /// pipeline than an optional value. The expected return types is a
    /// Publisher that returns either an empty list, or a list of one
    /// GithubAPUser, and with a failure return type of Never, so it's
    /// suitable for recurring pipeline updates working with a @Published
    /// data source.
    /// - Parameter username: username to be retrieved from the Github API
    ///
    static func retrieveGithubUser(username: String) -> AnyPublisher<[GithubAPIUser], Never> {
        if username.count < 3 {
            return Empty().eraseToAnyPublisher()
        }
        
        let assembledURL = URL(string: "https://api.github.com/users/\(username)")!
        let publisher = URLSession.shared.dataTaskPublisher(for: assembledURL)
            .handleEvents { subscription in
                print("Publisher Subscription: ", subscription)
                
                networkActivityPublisher.send(true)
            } receiveOutput: { data, response in
                print("Publisher Data: ", data)
                print("Publisher Response: ", response)
            } receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Publisher Finished")
                    
                    networkActivityPublisher.send(false)
                case .failure(let error):
                    print("Publisher Failure: ", error.localizedDescription)
                    
                    networkActivityPublisher.send(false)
                }
            } receiveCancel: {
                print("Publisher Cancel")
                
                networkActivityPublisher.send(false)
            } receiveRequest: { demand in
                print("Publisher Request: ", demand.description)
            }
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw APIFailureCondition.invalidServerResponse
                }
                
                return data
            }
            .decode(type: GithubAPIUser.self, decoder: JSONDecoder())
            .map { user -> [GithubAPIUser] in
                Thread.sleep(forTimeInterval: 3.0)
                return [user]
            }
            .replaceError(with: [])
        // ^^ when I originally wrote this method, I was returning
        // a GithubAPIUser? optional, and then a GithubAPIUser without
        // optional. I ended up converting this to return an empty
        // list as the "error output replacement" so that I could
        // represent that the current value requested didn't *have* a
        // correct github API response.
            .eraseToAnyPublisher()
        
        return publisher
    }
}


