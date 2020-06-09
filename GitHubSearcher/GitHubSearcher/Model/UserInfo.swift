//
//  searchContainer.swift
//  GitHubSearcher
//
//  Created by Hamzah Masood on 6/7/20.
//  Copyright © 2020 Hamzah Masood. All rights reserved.
//

import Foundation

struct UserInfo: Decodable {
    let login: String?
    let name: String?
    let avatarURL: URL?
    let location: String?
    let email: String?
    let bio: String?
    let repos: Int?
    let following: Int?
    let followers: Int?
    let joinDate: String?
    var reposURL: URL
    
    enum CodingKeys: String, CodingKey {
        case login
        case name
        case avatarURL = "avatar_url"
        case location
        case email
        case bio
        case repos = "public_repos"
        case followers
        case following
        case joinDate = "created_at"
        case reposURL = "repos_url"
    }

}
