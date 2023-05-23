//
//  SecondViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 22.02.2023.
//

import UIKit
import AVKit

protocol HomeViewControllerFBDeselectDelegate: AnyObject {
    func favoriteButtonDeselect()
}

protocol HomeViewControllerDelegate: AnyObject {
    func reloadFavoriteTableView()
}

final class FavoriteViewController: UIViewController {
    
    //MARK: - Public Properties
    
    weak var delegateNavigationItem: NavigationItemDelegate!
    var favoritesVideo: [Mask] = []
    
    // MARK: - Private Properties
    
    private var filteredCharacters: [Mask] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return !searchBarIsEmpty
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search on the FavoritePage"
        searchBar.tintColor = .black
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var favoriteListTableView: UITableView = {
        let favoriteListTableView = UITableView(frame: .zero, style: .insetGrouped)
        favoriteListTableView.translatesAutoresizingMaskIntoConstraints = false
        favoriteListTableView.dataSource = self
        favoriteListTableView.delegate = self
        favoriteListTableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        return favoriteListTableView
    }()
    
    private let segmentedItems = ["Favorite", "Viewed", "Description"]
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: segmentedItems)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.borderWidth = 0.5
        segmentedControl.layer.borderColor = UIColor.systemGray2.cgColor
        segmentedControl.tintColor = .white
        segmentedControl.backgroundColor = .white
        segmentedControl.addTarget(self, action: #selector(segmentedSlided), for: .valueChanged)
        return segmentedControl
    }()
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigation()
        fetchData()
        setupSearchButton()
    }
    
    // MARK: - Private Methods
    
    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let data):
                favoritesVideo = data
            case .failure(let error):
                print(error)
            }
        }
    }

    private func setupNavigation() {
        guard let naviVC = tabBarController?.viewControllers?[0] as? UINavigationController else {return}
        guard let homeVC = naviVC.topViewController as? HomeViewController else {return}
        homeVC.delegateFTVReloadData = self
        homeVC.delegateDeselectButton = self
    }
    
    private func setupSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc private func searchButtonPressed() {
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    @objc private func segmentedSlided() {
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            let viewedVideoVC = ViewedVideoViewViewController()
            present(viewedVideoVC, animated: true)
        case 2:
            let descriptionVC = DescriptionViewController()
            present(descriptionVC, animated: true)
        default:
            break
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor(hexString: "#f7f0f0")
        [favoriteListTableView, segmentedControl] .forEach {view.addSubview($0)}
        NSLayoutConstraint.activate([
            favoriteListTableView.topAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: 5),
            favoriteListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favoriteListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18)
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
        cell.selectionStyle = .none
        cell.getPlayButton = { [unowned self] in
            guard let videoURL = URL(string: favoriteVideo.sources ?? "") else { return }
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                player.play()
                cell.getButtonTittle()
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favoriteVideo = isFiltering ? filteredCharacters.remove(at: indexPath.row) : favoritesVideo.remove(at: indexPath.row)
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

extension FavoriteViewController: HomeViewControllerFBDeselectDelegate {
    func favoriteButtonDeselect() {
        let indexPath = IndexPath(row: favoritesVideo.count - 1, section: 0)
        let favoriteVideo = isFiltering ? filteredCharacters.remove(at: indexPath.row) : favoritesVideo.remove(at: indexPath.row)
        favoriteListTableView.deleteRows(at: [indexPath], with: .automatic)
        StorageManager.shared.delete(favoriteVideo)
    }
}

// MARK: - UISearchBarDelegate

extension FavoriteViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegateNavigationItem.getTitleView(self)
        setupSearchButton()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCharacters = favoritesVideo.filter { Mask in
            Mask.title?.lowercased().contains(searchText.lowercased()) ?? Bool()
        }
        favoriteListTableView.reloadData()
    }
}
