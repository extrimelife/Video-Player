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
    private let settingVC = SettingViewController()
    
    private let navigationPopImage: UIImageView = {
        let navigationPopImage = UIImageView()
        navigationPopImage.image = UIImage(named: "PopMovies naviBar")
        navigationPopImage.contentMode = .scaleAspectFit
        return navigationPopImage
    }()
    
    
    private let navigationImageView: UIImageView = {
        let naviImageView = UIImageView()
       // naviImageView.image = UIImage(named: "PopMovies naviBar")
        naviImageView.contentMode = .scaleAspectFit
        return naviImageView
    }()
    
    private lazy var naviHorizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [navigationPopImage])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = -185
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
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeViewController.delegateNavigationItem = self
        
        let favoriteVc = UINavigationController(rootViewController: favoriteViewController)
        favoriteVc.tabBarItem.title = "Favorite"
        favoriteVc.tabBarItem.image = UIImage(systemName: "heart")
        favoriteViewController.delegateNavigationItem = self
    
        let thirdVC = UINavigationController(rootViewController: thirdVC)
        thirdVC.tabBarItem.title = "Info"
        thirdVC.tabBarItem.image = UIImage(systemName: "info")
        
        let settingVC = UINavigationController(rootViewController: settingVC)
        settingVC.tabBarItem.title = "Setting"
        settingVC.tabBarItem.image = UIImage(systemName: "gear")
        
        viewControllers = [homeVC, favoriteVc, thirdVC, settingVC]
    }
    
    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(hexString: "#f7f0f0")
        let viewControllers = [homeViewController, favoriteViewController, thirdVC, settingVC]
        viewControllers .forEach { viewController in
            viewController.navigationItem.titleView = navigationPopImage
            viewController.navigationController?.navigationBar.standardAppearance = navBarAppearance
            viewController.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            naviHorizontalStackView.heightAnchor.constraint(equalToConstant: 20),
            naviHorizontalStackView.widthAnchor.constraint(equalToConstant: 190),
            naviVerticalStackView.widthAnchor.constraint(equalToConstant: 315)
        ])
    }
}

extension TabBarViewController: NavigationItemDelegate {
    func getTitleView(_ viewController: UIViewController) {
        viewController.navigationItem.titleView = naviVerticalStackView
    }
}

