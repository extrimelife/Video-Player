//
//  TabBarViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 22.02.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - Private Properties
    
    private let mainViewController = MainViewController()
    private let secondVC = SecondViewController()
    
    private let navigationLabel: UILabel = {
        let navigationLabel = UILabel()
        navigationLabel.text = "MeTube"
        navigationLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        navigationLabel.textColor = .white
        return navigationLabel
    }()
    
    private let navigationImageView: UIImageView = {
        let naviImageView = UIImageView(image: UIImage(named: "MeTube"))
        naviImageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        naviImageView.contentMode = .scaleAspectFit
        return naviImageView
    }()
    
    private lazy var navigationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [navigationImageView, navigationLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = -60
        stackView.frame.size = CGSize(
            width: navigationImageView.frame.size.width + navigationLabel.frame.size.width,
            height: max(navigationImageView.frame.size.height, navigationLabel.frame.size.height))
        return stackView
    }()
    
    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupNavigationBar()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigation() {
        let mainVC = UINavigationController(rootViewController: mainViewController)
        mainVC.tabBarItem.title = "Home"
        mainVC.tabBarItem.image = UIImage(systemName: "house")
        
        let secondVC = UINavigationController(rootViewController: secondVC)
        secondVC.tabBarItem.title = "Favorite"
        secondVC.tabBarItem.image = UIImage(systemName: "heart")
        
        viewControllers = [mainVC, secondVC]
    }
    
    private func setupNavigationBar() {
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(hexString: "#2e0142")
        mainViewController.navigationItem.titleView = navigationStackView
        mainViewController.navigationController?.navigationBar.standardAppearance = navBarAppearance
        mainViewController.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        mainViewController.navigationController?.navigationBar.tintColor = .white
    }
}

