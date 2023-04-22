//
//  SceneDelegate.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 22.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let tabBarViewController = TabBarViewController()
        let appearance = UITabBarAppearance()
        tabBarViewController.tabBar.scrollEdgeAppearance = appearance
        tabBarViewController.tabBar.unselectedItemTintColor = .systemGray
        tabBarViewController.tabBar.tintColor = .black
        tabBarViewController.tabBar.barTintColor = UIColor(hexString: "#f7f0f0")
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}

