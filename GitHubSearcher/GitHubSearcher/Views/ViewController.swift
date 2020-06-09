//
//  ViewController.swift
//  GitHubSearcher
//
//  Created by Hamzah Masood on 6/7/20.
//  Copyright © 2020 Hamzah Masood. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    let viewModel = ViewModel()
    var timer: Timer?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchResults: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "GitHub Searcher"
        
        searchResults.delegate = self
        searchResults.dataSource = self
        searchResults.register(UINib(nibName: "AvatarTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        searchBar.delegate = self
 
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AvatarTableViewCell
        cell.usernameLabel?.text = viewModel.userName(for: indexPath.row)
        viewModel.getUserInfo(index: indexPath.row) {
            DispatchQueue.main.async {
                cell.repoNumberLabel?.text = "Repo: \(self.viewModel.getUserRepo(for: indexPath.row) ?? 0)"
            }
        }
        
        if let userAvatarURL = viewModel.avatarURL(for: indexPath.row) {
            
            URLSession.shared.dataTask(with: userAvatarURL) { data,_,_  in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    cell.avatarImageView.image = UIImage(data: data)
                }
            }.resume()
        }
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(detailVC, animated: true)
        detailVC.selectedUserIndex = indexPath.row
        detailVC.viewModel = viewModel
        
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.viewModel.getData(searchText: searchText) { [weak self] in
                DispatchQueue.main.async {
                    self?.searchResults.reloadData()
                }
            }            
        })
    }

}

