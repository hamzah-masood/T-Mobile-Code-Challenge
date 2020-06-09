//
//  ViewModel.swift
//  GitHubSearcher
//
//  Created by Hamzah Masood on 6/7/20.
//  Copyright © 2020 Hamzah Masood. All rights reserved.
//

import Foundation

protocol Session {
    func getData(from request: URLRequest, completion: ((Data?, Error?) -> Void)?)
}
extension URLSession: Session {
    func getData(from request: URLRequest, completion: ((Data?, Error?) -> Void)?) {
        dataTask(with: request) { (data, _, error) in
            completion?(data, error)
        }.resume()
    }
}


final class ViewModel {
    private let searchURL = "https://api.github.com/search/users?q="
    var userArray: [Users] = []
    var infoArray: [UserInfo?] = []
    
    func getData(searchText: String,session: Session = URLSession.shared, _ completion: (() -> Void)?) {
        guard let searchUrl = URL(string: "https://api.github.com/search/users?q=\(searchText)") else {
            completion?()
            return
        }
        let request = URLRequest.init(url: searchUrl)
        
        session.getData(from: request) { [weak self] (data, error) in
            defer { completion?() }
            guard let data = data,
                error == nil,
                let searchResult = try? JSONDecoder().decode(Items.self, from: data) else { return }
            self?.userArray = searchResult.items ?? []
            self?.infoArray = [UserInfo?](repeating: nil, count: self?.userArray.count ?? 0)
        }
    }
    
    func getUserInfo(index: Int,session: Session = URLSession.shared, _ completion: (() -> Void)?) {
        guard let userURL = profileURL(for: index) else {
            completion?()
            return
        }
        let request = URLRequest.init(url: userURL)
        session.getData(from: request) { [weak self] (data, error) in
            defer { completion?() }
            guard let data = data,
                error == nil,
                let searchResult = try? JSONDecoder().decode(UserInfo.self, from: data) else { return }
            guard index < (self?.infoArray.count ?? 0) else{
                completion?()
                return
            }
            self?.infoArray[index] = searchResult
            
        }
    }
    
    func user(for index: Int) -> Users {
        return self.userArray[index]
    }
    
    func numberOfUsers() -> Int {
        return self.userArray.count
    }
    
    func userName(for index: Int) -> String? {
        return self.userArray[index].login
    }
    
    func avatarURL(for index: Int) -> URL? {
        return self.userArray[index].avatarURL
    }
    
    func profileURL(for index: Int) -> URL? {
        return self.userArray[index].url
    }
    
    func getUserRepo(for index: Int) -> Int? {
        return self.infoArray.getElementIfPossible(for: index)??.repos
    }
    
    func getUserAvatar(for index: Int) -> URL? {
        return self.infoArray.getElementIfPossible(for: index)??.avatarURL
    }
    
    func getUserLocation(for index: Int) -> String? {
        return self.infoArray.getElementIfPossible(for: index)??.location
    }
    
    func getUserEmail(for index: Int) -> String? {
        
        return self.infoArray.getElementIfPossible(for: index)??.email
    }
    
    func getUserBio(for index: Int) -> String? {
        return self.infoArray.getElementIfPossible(for: index)??.bio
    }
    
    func getUserFollowing(for index: Int) -> Int? {
        return self.infoArray.getElementIfPossible(for: index)??.following
    }
    
    func getUserFollowers(for index: Int) -> Int? {
        return self.infoArray.getElementIfPossible(for: index)??.followers
    }
    
    func getUserJoinDate(for index: Int) -> String? {
        return self.infoArray.getElementIfPossible(for: index)??.joinDate
    }
    
    func getUserReposURL(for index: Int) -> URL? {
        return self.infoArray.getElementIfPossible(for: index)??.reposURL
    }
    
}

extension Array {
    func getElementIfPossible(for index: Int) -> Element? {
        guard index < self.count && index >= 0 else {
            return nil
        }
        return self[index]
    }
}
