//
//  DetailViewController.swift
//  GitHubSearcher
//
//  Created by Hamzah Masood on 6/8/20.
//  Copyright © 2020 Hamzah Masood. All rights reserved.
//

import Foundation
import UIKit

final class DetailViewController: UIViewController {
    
    var viewModel: ViewModel!
    var detailViewModel = DetailViewModel()
    var selectedUserIndex = 0
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var FollowingLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var repoSearchBar: UISearchBar!
    @IBOutlet weak var repoTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        repoTableView.delegate = self
        repoTableView.dataSource = self
        repoTableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        repoSearchBar.delegate = self
        
        if let newRepoURL = viewModel.getUserReposURL(for: selectedUserIndex) {
            detailViewModel.getUserRepoData(userRepoURL: newRepoURL) {
                DispatchQueue.main.async { [weak self] in
                    
                    self?.repoTableView.reloadData()
                }
            }
        }
        
        if let userAvatarURL = viewModel.getUserAvatar(for: selectedUserIndex) {
            URLSession.shared.dataTask(with: userAvatarURL) { data,_,_  in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.avatarImageView.image = UIImage(data: data)
                }
            }.resume()
        }
        nameLabel.text? = viewModel.userName(for: selectedUserIndex) ?? "N/A"
        nameLabel.numberOfLines = 0
        emailLabel.text? = viewModel.getUserEmail(for: selectedUserIndex) ?? "N/A"
        emailLabel.numberOfLines = 0
        locationLabel.text? = viewModel.getUserLocation(for: selectedUserIndex) ?? "N/A"
        locationLabel.numberOfLines = 0

        guard let initialJoinDate = DateFormatters.serverDateFormatter.date(from: viewModel.getUserJoinDate(for: selectedUserIndex) ?? "N/A") else {return}
        let newJoinDate = (DateFormatters.userFriendlyDateFormatter.string(from: initialJoinDate))
        
        joinDateLabel.text? = newJoinDate
        joinDateLabel.numberOfLines = 0
        bioLabel.text? = viewModel.getUserBio(for: selectedUserIndex) ?? "N/A"
        bioLabel.numberOfLines = 0
        followerLabel.text? = "\(viewModel.getUserFollowers(for: selectedUserIndex) ?? 0) Followers"
        FollowingLabel.text? = "Following \(viewModel.getUserFollowers(for: selectedUserIndex) ?? 0)"
    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return detailViewModel.numberOfRepos() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailTableViewCell
        cell.repoNameLabel?.text = detailViewModel.getRepoName(for: indexPath.row)
        cell.starLabel?.text = "\(detailViewModel.getRepoStarCount(for: indexPath.row) ?? 0) Stars"
        cell.forkLabel?.text = "\(detailViewModel.getRepoForkCount(for: indexPath.row) ?? 0) Forks"
        
        return cell
        
    }
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = detailViewModel.getRepoURL(for: indexPath.row)
        UIApplication.shared.open(url)
    }
}


extension DetailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        detailViewModel.filterRepos(by: searchText)
        repoTableView.reloadData()
    }
}

