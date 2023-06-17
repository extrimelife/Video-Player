//
//  ViewControllerViewViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 26.04.2023.
//

import UIKit

protocol GetViewedVideoDelegate: AnyObject {
    func getVideo()
}

final class ViewedVideoViewViewController: UIViewController {
    
    private var viewedVideo = [Mask]()
    private let emptyView = EmptyView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .brown
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupLayout()
        showEmptyView()
        setupNavigation()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupNavigation() {
        guard let navigationVC = tabBarController?.viewControllers?.last as? UINavigationController else { return }
        guard let favoriteVC = navigationVC.topViewController as? FavoriteViewController else { return }
        favoriteVC.delegateGetViewedVideo = self
    }
    
    private func showEmptyView() {
        if viewedVideo.isEmpty {
            emptyView.show(title: "No videos viewed yet",
                           image: UIImage(named: "notFavorite") ?? UIImage())
            layoutEmptyView()
        } else {
            emptyView.hide()
        }
    }
    
    private func layoutEmptyView() {
        emptyView.frame = view.bounds
        view.addSubview(emptyView)
    }
    
    private func setupLayout() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension ViewedVideoViewViewController: GetViewedVideoDelegate {
    func getVideo() {
        view.backgroundColor = .brown
    }
}
