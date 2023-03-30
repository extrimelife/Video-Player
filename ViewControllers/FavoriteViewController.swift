//
//  SecondViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 22.02.2023.
//

import UIKit
import AVKit

protocol HomeViewControllerDelegate: AnyObject {
    func reloadFavoriteTableView()
}

final class FavoriteViewController: UIViewController {
    
    // MARK: - Private Properties
    
    var favoritesVideo: [Mask] = []
    private var videoPlayerData = [Category]()
    
    private lazy var favoriteListTableView: UITableView = {
        let favoriteListTableView = UITableView(frame: .zero, style: .insetGrouped)
        favoriteListTableView.translatesAutoresizingMaskIntoConstraints = false
        favoriteListTableView.dataSource = self
        favoriteListTableView.delegate = self
        favoriteListTableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        return favoriteListTableView
    }()
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigation()
        fetchData()
        fetchVideoData()
    }
    
    func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let data):
                favoritesVideo = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchVideoData() {
        NetworkManager.shared.fetchData { [unowned self] result in
            videoPlayerData = result
        }
    }
    
    private func setupNavigation() {
        guard let naviVC = tabBarController?.viewControllers?[0] as? UINavigationController else {return}
        guard let homeVC = naviVC.topViewController as? HomeViewController else {return}
        homeVC.delegateFTVReloadData = self
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        view.addSubview(favoriteListTableView)
        NSLayoutConstraint.activate([
            favoriteListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            favoriteListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favoriteListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoritesVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell else { return FavoriteTableViewCell() }
        let favoriteVideo = favoritesVideo[indexPath.row]
        cell.configurateCell(categories: favoriteVideo)
        cell.backgroundColor = UIColor(hexString: "#f7f0f0")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videoPlayerData[indexPath.section].videos[indexPath.row]
        guard let videoURL = URL(string: video.sources) else { return }
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true)
        player.play()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favoriteVideo = favoritesVideo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(favoriteVideo)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}

extension FavoriteViewController: HomeViewControllerDelegate {
    func reloadFavoriteTableView() {
        favoriteListTableView.reloadData()
    }
}
