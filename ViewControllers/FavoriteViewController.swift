//
//  SecondViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 22.02.2023.
//

import UIKit
import AVKit

protocol SearchBarFavoriteVCDelegate: AnyObject {
    func getSearchBarFVC(_ searchText: String)
}

protocol HomeViewControllerFBDeselectDelegate: AnyObject {
    func favoriteButtonDeselect()
}

protocol HomeViewControllerDelegate: AnyObject {
    func reloadFavoriteTableView()
}

final class FavoriteViewController: UIViewController {
    
    
    //MARK: - Public Properties

    var favoritesVideo: [Mask] = []
    
    // MARK: - Private Properties
    
    private var videoPlayerData = [Category]()
    private var filteredCharacters: [Mask] = []
    private let searchBar = UISearchBar()
    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return !searchBarIsEmpty
    }
    
    lazy var favoriteListTableView: UITableView = {
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
        fetchVideoData()
        fetchData()
        setupTabBar()
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
        homeVC.delegateDeselectButton = self
    }
    func setupTabBar() {
        guard let navigationBar = tabBarController?.viewControllers?.first as? UINavigationController else { return }
        guard let tabBar = navigationBar.tabBarController as? TabBarViewController else { return }
        tabBar.delegateSearchBarFavoriteVC = self
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
        isFiltering ? filteredCharacters.count : favoritesVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell else { return FavoriteTableViewCell() }
        let favoriteVideo = isFiltering ? filteredCharacters[indexPath.row] : favoritesVideo[indexPath.row]
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
            let favoriteVideo = isFiltering ? filteredCharacters.remove(at: indexPath.row) : favoritesVideo.remove(at: indexPath.row)
            favoriteListTableView.deleteRows(at: [indexPath], with: .automatic)
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

extension FavoriteViewController: HomeViewControllerFBDeselectDelegate {
    func favoriteButtonDeselect() {
        let indexPath = IndexPath(row: favoritesVideo.count - 1, section: 0)
        let favoriteVideo = favoritesVideo.remove(at: indexPath.row)
        favoriteListTableView.deleteRows(at: [indexPath], with: .automatic)
        StorageManager.shared.delete(favoriteVideo)
    }
}

extension FavoriteViewController: SearchBarFavoriteVCDelegate {
    func getSearchBarFVC(_ searchText: String) {
        searchBar.text = searchText
        filteredCharacters = favoritesVideo.filter { mask in
            mask.title?.lowercased().contains(searchText.lowercased()) ?? true
        }
        favoriteListTableView.reloadData()
    }
}

