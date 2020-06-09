//
//  Users.swift
//  GitHubSearcher
//
//  Created by Hamzah Masood on 6/8/20.
//  Copyright © 2020 Hamzah Masood. All rights reserved.
//

import Foundation

struct Users: Decodable {
    var login: String
    var avatarURL: URL?
    var url: URL?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case url
        
    }
}
