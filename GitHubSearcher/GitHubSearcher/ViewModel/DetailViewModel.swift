//
//  DetailViewModel.swift
//  GitHubSearcher
//
//  Created by Hamzah Masood on 6/8/20.
//  Copyright © 2020 Hamzah Masood. All rights reserved.
//

import Foundation


final class DetailViewModel {
    
    private let searchURL = "https://api.github.com/search/users?q="//\(searchQuery)"
    var userArray: [Users] = []
    var infoArray: [UserInfo?] = []//(repeating: nil, count: user.count)
    var userRepoData: [UserRepoInfo] = []
    var filterRepoData: [UserRepoInfo] = []
    
    func getUserRepoData(userRepoURL: URL,session: Session = URLSession.shared, _ completion: (() -> Void)?) {

        let request = URLRequest.init(url: userRepoURL)
        session.getData(from: request) { [weak self] (data, error) in
            defer { completion?() }
            guard let data = data,
                error == nil,
                let searchResult = try? JSONDecoder().decode([UserRepoInfo].self, from: data) else { return }
            self?.userRepoData = searchResult
            self?.filterRepoData = searchResult
                        
        }
    }
    
    
    func numberOfRepos() -> Int? {
        return self.filterRepoData.count
    }
    func getRepoName(for index: Int) -> String {
        return self.filterRepoData[index].name
    }
    func getRepoStarCount(for index: Int) -> Int? {
        return self.filterRepoData[index].starCount
    }
    func getRepoForkCount(for index: Int) -> Int? {
        return self.filterRepoData[index].forkCount
    }
    func getRepoURL(for index: Int) -> URL {
        return self.filterRepoData[index].HTMLUrl
    }
    func getRepo(for index: Int) -> UserRepoInfo {
        return self.filterRepoData[index]
    }
    func getAllRepo(for index: Int) -> [UserRepoInfo] {
        return self.filterRepoData
    }
    func filterRepos(by search: String) {
        
        guard !search.isEmpty else {
            self.filterRepoData = self.userRepoData
            return
        }
        self.filterRepoData = self.userRepoData.filter({ (repo) -> Bool in
            return repo.name.lowercased().contains(search.lowercased())
        })
    }

}


