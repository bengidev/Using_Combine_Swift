//
//  HomeViewModel.swift
//  GitHub Combine UIKit
//
//  Created by Bambang Tri Rahmat Doni on 03/01/24.
//

import Combine
import Foundation
import UIKit

final class HomeViewModel: NSObject {
    // Username from the github_id_entry field
    //
    @Published var username: String = "" {
        didSet {
            print("Set username to: ", username)
        }
    }
    
    // Github user retrieved from the API publisher. As it's updated,
    // it is "wired" to update UI elements
    //
    @Published private var githubUserData: [GithubAPIUser] = [] {
        didSet {
            print("Set githubUserData to: ", githubUserData)
        }
    }
    
    private(set) var profileImageSubscriber: AnyCancellable?
    private(set) var nameSubscriber: AnyCancellable?
    private(set) var usernameSubscriber: AnyCancellable?
    private(set) var bioSubscriber: AnyCancellable?
    private(set) var locationSubscriber: AnyCancellable?
    private(set) var reposTotalSubscriber: AnyCancellable?
    private(set) var gistsTotalSubscriber: AnyCancellable?
    private(set) var sinceSubscriber: AnyCancellable?
    private(set) var apiNetworkActivitySubscriber: AnyCancellable?
    
    func startApiNetworkProcess(action: @escaping (Bool) -> Void) -> Void {
        apiNetworkActivitySubscriber = GithubAPI.networkActivityPublisher
            .receive(on: DispatchQueue.main)
            .sink { action($0) }
    }
    
    func startUsernameProgress() -> Void {
        usernameSubscriber = $username
            .throttle(for: 0.5, scheduler: DispatchQueue.global(qos: .background), latest: true)
        // ^^ scheduler myBackGroundQueue publishes resulting elements
        // into that queue, resulting on this processing moving off the
        // main runloop.
            .removeDuplicates()
            .print("username pipeline: ") // debugging output for pipeline
            .map { username -> AnyPublisher<[GithubAPIUser], Never>  in
                GithubAPI.retrieveGithubUser(username: username)
            }
        // ^^ type returned in the pipeline is a Publisher, so we use
        // switchToLatest to flatten the values out of that
        // pipeline to return down the chain, rather than returning a
        // publisher down the pipeline.
            .switchToLatest()
        // using a sink to get the results from the API search lets us
        // get not only the user, but also any errors attempting to get it.
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.githubUserData, on: self)
    }
    
    func startRepositoriesProcess(action: @escaping (String) -> Void) -> Void {
        // using .assign() on the other hand (which returns an
        // AnyCancellable) *DOES* require a Failure type of <Never>
        reposTotalSubscriber = $githubUserData
            .print("github user data: ")
            .map { userData -> String in
                if let firstUser = userData.first {
                    return String(firstUser.publicRepos)
                }
                
                return "unknown"
            }
            .receive(on: DispatchQueue.main)
            .sink { result in action(result) }
    }
    
    func startProfileImageProcess(action: @escaping (Bool, UIImage) -> Void) -> Void {
        profileImageSubscriber = $githubUserData
        // When I first wrote this publisher pipeline, the type I was
        // aiming for was <GithubAPIUser?, Never>, where the value was an
        // optional. The commented out .filter below was to prevent a `nil` // GithubAPIUser object from propagating further and attempting to
        // invoke the dataTaskPublisher which retrieves the avatar image.
        //
        // When I updated the type to be non-optional (<GithubAPIUser?,
        // Never>) the filter expression was no longer needed, but possibly
        // interesting.
        // .filter({ possibleUser -> Bool in
        //     possibleUser != nil
        // })
        // .print("avatar image for user") // debugging output
            .map { userData -> AnyPublisher<UIImage, Never> in
                guard let firstUser = userData.first else {
                    // my placeholder data being returned below is an empty
                    // UIImage() instance, which simply clears the display.
                    // Your use case may be better served with an explicit
                    // placeholder image in the event of this error condition.
                    return Just(UIImage()).eraseToAnyPublisher()
                }
                
                return URLSession.shared.dataTaskPublisher(for: .init(string: firstUser.avatarURL)!)
                // ^^ this hands back (Data, response) objects
                    .handleEvents { subscription in
                        print("profileImageSubscriber subscription: ", subscription)
                        action(true, .init())
                    } receiveOutput: { data, response in
                        print("profileImageSubscriber receiveOutput: ", data)
                    } receiveCompletion: { completion in
                        print("profileImageSubscriber receiveCompletion: ", completion)
                        action(false, .init())
                    } receiveCancel: {
                        print("profileImageSubscriber receiveCancel: ")
                        action(false, .init())
                    } receiveRequest: { demand in
                        print("profileImageSubscriber receiveRequest: ", demand.description)
                    }
                    .map { $0.data }
                // ^^ pare down to just the Data object
                    .map { UIImage(data: $0) ?? .init() }
                // ^^ convert Data into a UIImage with its initializer
                    .subscribe(on: DispatchQueue.global(qos: .background))
                // ^^ do this work on a background Queue so we don't screw
                // with the UI responsiveness
                    .catch { _ in Just(UIImage()) }
                // ^^ deal the failure scenario and return my "replacement"
                // image for when an avatar image either isn't available or
                // fails somewhere in the pipeline here.
                    .eraseToAnyPublisher()
                // ^^ match the return type here to the return type defined
                // in the .map() wrapping this because otherwise the return
                // type would be terribly complex nested set of generics.
            }
            .switchToLatest()
        // ^^ Take the returned publisher that's been passed down the chain
        // and "subscribe it out" to the value within in, and then pass
        // that further down.
            .subscribe(on: DispatchQueue.global(qos: .background))
        // ^^ do the above processing as well on a background Queue rather
        // than potentially impacting the UI responsiveness
            .receive(on: DispatchQueue.main)
        // ^^ and then switch to receive and process the data on the main
        // queue since we're messing with the UI
            .map { image -> UIImage? in
                return image }
        // ^^ this converts from the type UIImage to the type UIImage?
        // which is key to making it work correctly with the .assign()
        // operator, which must map the type *exactly*
            .sink { result in action(false, result ?? .init()) }
    }
}


