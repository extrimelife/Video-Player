//
//  ViewControllerViewViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 26.04.2023.
//

import UIKit

final class ViewedVideoViewViewController: UIViewController {
    
    var viewedVideo = [Mask]()
    private let emptyView = EmptyView()
    
     let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupLayout()
    }
    
    private func showEmptyView() {
        if viewedVideo.isEmpty {
            emptyView.show(title: "No viewed video yet",
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
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
