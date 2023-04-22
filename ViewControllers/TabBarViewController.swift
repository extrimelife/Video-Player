//
//  TabBarViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 22.02.2023.
//

import UIKit

protocol NavigationItemDelegate: AnyObject {
    func getTitleView(_ viewController: UIViewController)
}

final class TabBarViewController: UITabBarController {

    // MARK: - Private Properties
    
    private let homeViewController = HomeViewController()
    private let favoriteViewController = FavoriteViewController()
    private let thirdVC = InfoViewController()
    
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
    
    override func viewDidLayoutSubviews() {
        getTabBarHeight()
    }
    
    // MARK: - Private Methods
    
    private func getTabBarHeight() {
            var frame = tabBar.frame
            frame.size.height = 80
            frame.origin.y = view.frame.size.height - 68
            tabBar.frame = frame
    }
    
    private func setupNavigation() {
        let homeVC = UINavigationController(rootViewController: homeViewController)
        homeVC.tabBarItem.title = "Home"
        homeVC.tabBarItem.image = UIImage(named: "home2")
        homeViewController.delegateNavigationItem = self
        
        let favoriteVc = UINavigationController(rootViewController: favoriteViewController)
        favoriteVc.tabBarItem.title = "Favorite"
        favoriteVc.tabBarItem.image = UIImage(named: "heart")
        favoriteViewController.delegateNavigationItem = self
    
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
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            naviHorizontalStackView.heightAnchor.constraint(equalToConstant: 20),
            naviHorizontalStackView.widthAnchor.constraint(equalToConstant: 190),
            naviVerticalStackView.widthAnchor.constraint(equalToConstant: 310)
        ])
    }
}

extension TabBarViewController: NavigationItemDelegate {
    func getTitleView(_ viewController: UIViewController) {
        viewController.navigationItem.titleView = naviVerticalStackView
    }
}

