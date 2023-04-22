//
//  MainViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 22.02.2023.
//

import UIKit
import AVKit

protocol HomeCollectionViewCellDelegate: AnyObject {
    func favoriteButtonPressed(image: Data, title: String, tintColor: Data, tag: Int16)
}

final class HomeViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegateNavigationItem: NavigationItemDelegate!
    weak var delegateDeselectButton: HomeViewControllerFBDeselectDelegate!
    weak var delegateFTVReloadData: HomeViewControllerDelegate!
    
    // MARK: - Private properties
    
    private var categoryModel = [Category]()
    private var filteredCharacters: [Video] = []
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
        searchBar.placeholder = "Search on the HomePage"
        searchBar.tintColor = .black
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var homeCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        let homeVollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        homeVollectionView.translatesAutoresizingMaskIntoConstraints = false
        homeVollectionView.register(HomelCollectionViewCell.self, forCellWithReuseIdentifier: HomelCollectionViewCell.identifier)
        homeVollectionView.dataSource = self
        homeVollectionView.delegate = self
        return homeVollectionView
    }()
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        fetchData()
        setupSearchButton()
    }
    
    // MARK: - Private Methods
    
    private func fetchData() {
        NetworkManager.shared.fetchData { [unowned self] result in
            categoryModel = result
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
    
    private func setupLayout() {
        view.addSubview(homeCollectionView)
        NSLayoutConstraint.activate([
            homeCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            homeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            homeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isFiltering ? filteredCharacters.count : categoryModel[section].videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomelCollectionViewCell.identifier, for: indexPath) as? HomelCollectionViewCell else { return HomelCollectionViewCell() }
        let categoryModel = isFiltering ? filteredCharacters[indexPath.item] : categoryModel[indexPath.section].videos[indexPath.item]
        cell.configure(categories: categoryModel, index: indexPath.row)
        cell.backgroundColor = UIColor(hexString: "#f7f0f0")
        cell.delegateFBGesture = self
        cell.favoriteButtonDeselect = {
            self.delegateDeselectButton.favoriteButtonDeselect()
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    private var sizeInset: CGFloat { return 16 }
    private var height: CGFloat { return 100}
    private var minimumLineSpacingForSectionAt: CGFloat { return 50}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - sizeInset * 3) / 2
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        minimumLineSpacingForSectionAt
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: sizeInset, left: sizeInset, bottom: sizeInset, right: sizeInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sizeInset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = isFiltering ? filteredCharacters[indexPath.item] : categoryModel[indexPath.section].videos[indexPath.row]
        guard let videoURL = URL(string: video.sources) else {return}
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            player.play()
        }
    }
}

// MARK: - HomeCollectionViewCellDelegate

extension HomeViewController: HomeCollectionViewCellDelegate {
    func favoriteButtonPressed(image: Data, title: String, tintColor: Data, tag: Int16) {
        tabBarController?.selectedIndex = 1
        guard let navigationVC = tabBarController?.viewControllers?[1] as? UINavigationController else { return }
        guard let favoriteVC = navigationVC.topViewController as? FavoriteViewController else { return }
        StorageManager.shared.create(image, title, tintColor, tag) { mask in
            favoriteVC.favoritesVideo.append(mask)
            delegateFTVReloadData?.reloadFavoriteTableView()
        }
    }
}

// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegateNavigationItem.getTitleView(self)
        setupSearchButton()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let indexPath = IndexPath(row: categoryModel.count - 1, section: 0)
        filteredCharacters = categoryModel[indexPath.row].videos.filter { Video in
            Video.title.lowercased().contains(searchText.lowercased())
        }
        homeCollectionView.reloadData()
    }
}


