//
//  ViewControllerViewViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 26.04.2023.
//

import UIKit

class ViewedVideoViewViewController: UIViewController {
    
    private let emptyView = EmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        showEmptyView()
    }
    
    private func showEmptyView() {
        emptyView.show(title: "No videos viewed yet",
                       image: UIImage(named: "notFavorite") ?? UIImage())
        layoutEmptyView()
    }
    
    private func layoutEmptyView() {
        emptyView.frame = view.bounds
        view.addSubview(emptyView)
    }
}
