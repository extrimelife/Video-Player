//
//  TabBarViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 22.02.2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let mainViewController = MainViewController()
    let secondVC = SecondViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let mainVC = UINavigationController(rootViewController: mainViewController)
        mainVC.tabBarItem.title = "Video"
        mainVC.tabBarItem.image = UIImage(systemName: "house")
        mainVC.navigationItem.title = "Video"
        
        let secondVC = UINavigationController(rootViewController: secondVC)
        secondVC.tabBarItem.title = "Favorite"
        secondVC.navigationItem.title = "feffef"
        
        viewControllers = [mainVC, secondVC]
    }
}

