//
//  TabBarViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 22.02.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - Public Properties
    
    weak var deleagteSearchBarHomeVC: SearchBarHomeVCDelegate!
    weak var delegateSearchBarFavoriteVC: SearchBarFavoriteVCDelegate!
    
    // MARK: - Private Properties
    
    private let homeViewController = HomeViewController()
    private let favoriteViewController = FavoriteViewController()
    private let thirdVC = InfoViewController()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.tintColor = .black
        searchBar.sizeToFit()
        searchBar.delegate = self
        return searchBar
    }()
    
    private let navigationLabel: UILabel = {
        let navigationLabel = UILabel()
        navigationLabel.text = "MeTube"
        navigationLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        navigationLabel.textColor = .black
        navigationLabel.textAlignment = .left
        return navigationLabel
    }()
    
    private let navigationImageView: UIImageView = {
        let naviImageView = UIImageView()
        naviImageView.image = UIImage(named: "MeTube")
        naviImageView.contentMode = .scaleAspectFit
        return naviImageView
    }()
    
    private lazy var naviHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [navigationImageView, navigationLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = -195
        return stackView
    }()
    
    private lazy var naviVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.addArrangedSubview(naviHorizontalStackView)
        return stackView
    }()
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupNavigationBar()
        setupLayout()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigation() {
        let homeVC = UINavigationController(rootViewController: homeViewController)
        homeVC.tabBarItem.title = "Home"
        homeVC.tabBarItem.image = UIImage(named: "home2")
        homeViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonHVCPressed))
        homeViewController.navigationItem.rightBarButtonItem?.tintColor = .black
        
        let favoriteVc = UINavigationController(rootViewController: favoriteViewController)
        favoriteVc.tabBarItem.title = "Favorite"
        favoriteVc.tabBarItem.image = UIImage(named: "heart")
        favoriteViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonFVCPressed))
        favoriteViewController.navigationItem.rightBarButtonItem?.tintColor = .black
        
        let thirdVC = UINavigationController(rootViewController: thirdVC)
        thirdVC.tabBarItem.title = "Info"
        thirdVC.tabBarItem.image = UIImage(named: "info")
        
        viewControllers = [homeVC, favoriteVc, thirdVC]
    }
    
    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(hexString: "#f7f0f0")
        let viewControllers = [homeViewController, favoriteViewController, thirdVC]
        viewControllers .forEach { viewController in
            viewController.navigationItem.titleView = naviVerticalStackView
            viewController.navigationController?.navigationBar.standardAppearance = navBarAppearance
            viewController.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    @objc private func searchButtonHVCPressed() {
        setupNavigationVC(controller: homeViewController)
    }
    
    @objc private func searchButtonFVCPressed() {
        setupNavigationVC(controller: favoriteViewController)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            naviHorizontalStackView.heightAnchor.constraint(equalToConstant: 20),
            naviHorizontalStackView.widthAnchor.constraint(equalToConstant: 190),
            naviVerticalStackView.widthAnchor.constraint(equalToConstant: 310)
        ])
    }
}

// MARK: - UISearchBarDelegate

extension TabBarViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        homeViewController.navigationItem.titleView = naviVerticalStackView
        homeViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonHVCPressed))
        homeViewController.navigationItem.rightBarButtonItem?.tintColor = .black
        favoriteViewController.navigationItem.titleView = naviVerticalStackView
        favoriteViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonFVCPressed))
        favoriteViewController.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deleagteSearchBarHomeVC.getSearchBar(searchText)
        delegateSearchBarFavoriteVC.getSearchBarFVC(searchText)
    }
}

// MARK: - TabBarViewController

extension TabBarViewController {
    private func setupNavigationVC(controller: UIViewController) {
        controller.navigationItem.titleView = searchBar
        controller.navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
}
