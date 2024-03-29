//
//  SecondViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 22.02.2023.
//

import UIKit
import AVKit

final class FavoriteViewController: UIViewController {
    
    //MARK: - Public Properties
    let viewedVideoVC = ViewedVideoViewController()
    weak var delegateNavigationItem: NavigationItemDelegate!
    weak var delegateReloadHomeView: ReloadHomeTableViewDelegate!
    
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
    private let emptyView = EmptyView()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search on the FavoritePage"
        searchBar.tintColor = .black
        searchBar.delegate = self
        searchBar.searchTextField.clearButtonMode = .never
        return searchBar
    }()
    
    private lazy var favoriteListTableView: UITableView = {
        let favoriteListTableView = UITableView(frame: .zero, style: .insetGrouped)
        favoriteListTableView.translatesAutoresizingMaskIntoConstraints = false
        favoriteListTableView.dataSource = self
        favoriteListTableView.delegate = self
        favoriteListTableView.rowHeight = 200
        favoriteListTableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        favoriteListTableView.backgroundColor = UIColor(hexString: "#f7f0f0")
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
        segmentedControl.backgroundColor = UIColor(hexString: "#f7f0f0")
        segmentedControl.selectedSegmentTintColor = UIColor(hexString: "#f7f0f0")
        segmentedControl.addTarget(self, action: #selector(segmentedSlided), for: .valueChanged)
        return segmentedControl
    }()
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupSearchButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        showEmptyView()
    }
    
    // MARK: - Private Methods
    
    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let data):
                favoritesVideo = data
                favoriteListTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
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
            viewedVideoVC.navigationItem.title = segmentedControl.titleForSegment(at: 1)
            navigationController?.pushViewController(viewedVideoVC, animated: true)
        case 2:
            let descriptionVC = DescriptionViewController()
            present(descriptionVC, animated: true)
        default:
            break
        }
    }
    
    private func showEmptyView() {
        if favoritesVideo.isEmpty {
            segmentedControl.isHidden = true
            emptyView.show(title: "You haven't\nfavorite movies yet",
                           image: UIImage(named: "notFavorite") ?? UIImage())
            layoutEmptyView()
        } else {
            emptyView.hide()
            segmentedControl.isHidden = false
        }
    }
    
    private func showEmptyViewWrongSearch() {
        if filteredCharacters.isEmpty {
            segmentedControl.isHidden = true
            emptyView.show(title: "There aren't video\n this genre here!",
                           image: UIImage(named: "WrongSearch") ?? UIImage())
            layoutEmptyView()
        } else {
            emptyView.hide()
            segmentedControl.isHidden = false
        }
    }
    
    private func layoutEmptyView() {
        emptyView.frame = view.bounds
        view.addSubview(emptyView)
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
        cell.getReloadHomeVC = { [unowned self] in
            delegateReloadHomeView.reloadData()
        }
        cell.getPlayButton = { [unowned self] in
            viewedVideoVC.getVideo(video: favoriteVideo)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trashAction = UIContextualAction(style: .normal, title: "Delete") { [unowned self] action, view, completion in
            let favoriteVideo = isFiltering ? filteredCharacters.remove(at: indexPath.row) : favoritesVideo.remove(at: indexPath.row)
            StorageManager.shared.removeFavoriteMovie(id: favoriteVideo.id ?? "")
            favoriteListTableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
            delegateReloadHomeView.reloadData()
            showEmptyView()
        }
        trashAction.backgroundColor = .red
        trashAction.image = UIImage(named: "Trash")
        let configuration = UISwipeActionsConfiguration(actions: [trashAction])
        return configuration
    }
}

// MARK: - UISearchBarDelegate

extension FavoriteViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        delegateNavigationItem.getTitleView(self)
        setupSearchButton()
        showEmptyView()
        favoriteListTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCharacters = favoritesVideo.filter { Mask in
            Mask.title?.lowercased().contains(searchText.lowercased()) ?? Bool()
        }
        if isFiltering {
            showEmptyViewWrongSearch()
        } else {
            emptyView.hide()
        }
        favoriteListTableView.reloadData()
    }
}

