//
//  ViewControllerViewViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 26.04.2023.
//

import UIKit

class ViewedVideoViewViewController: UIViewController {
    
    private let viewedVideo = [Mask]()
    private let emptyView = EmptyView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        showEmptyView()
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
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
