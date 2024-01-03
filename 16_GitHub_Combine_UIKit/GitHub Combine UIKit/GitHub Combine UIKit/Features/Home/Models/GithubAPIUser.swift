//
//  GithubAPIUser.swift
//  GitHub Combine UIKit
//
//  Created by Bambang Tri Rahmat Doni on 03/01/24.
//

import Foundation

struct GithubAPIUser: Identifiable, Codable {
    // A very *small* subset of the content available about
    //  a github API user for example:
    // https://api.github.com/users/bengidev
    
    var id = UUID()
    let name: String
    let login: String
    let bio: String
    let publicRepos: Int
    let publicGists: Int
    let since: String
    let avatarURL: String
    let location: String
    
    static let empty: GithubAPIUser = .init(
        name: "",
        login: "",
        bio: "",
        publicRepos: 0,
        publicGists: 0,
        since: "",
        avatarURL: "",
        location: ""
    )
    
    enum CodingKeys: String, CodingKey {
        case name
        case login
        case bio
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case since = "created_at"
        case avatarURL = "avatar_url"
        case location
    }
}

