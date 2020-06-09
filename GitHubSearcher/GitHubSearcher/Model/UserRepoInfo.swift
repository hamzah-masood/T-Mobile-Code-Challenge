//
//  UserRepoInfo.swift
//  GitHubSearcher
//
//  Created by Hamzah Masood on 6/8/20.
//  Copyright © 2020 Hamzah Masood. All rights reserved.
//

import Foundation

struct UserRepoInfo: Decodable {
    var name: String
    var starCount: Int?
    var forkCount: Int?
    var HTMLUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case name
        case starCount = "stargazers_count"
        case forkCount = "forks"
        case HTMLUrl = "html_url"
    }
}
