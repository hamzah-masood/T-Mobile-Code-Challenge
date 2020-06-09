//
//  DateFormatter.swift
//  GitHubSearcher
//
//  Created by Hamzah Masood on 6/9/20.
//  Copyright © 2020 Hamzah Masood. All rights reserved.
//

import Foundation

enum DateFormatters {
    static let serverDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter
    }()
    
    static let userFriendlyDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        return dateFormatter
    }()
}

