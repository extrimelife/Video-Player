//
//  ViewControllerViewViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 26.04.2023.
//

import UIKit

class ViewedVideoViewViewController: UIViewController {
    
    private var viewedVideo = [Mask]()
    
    private lazy var viewedTableView: UITableView = {
        let viewedTableView = UITableView(frame: .zero, style: .insetGrouped)
        viewedTableView.translatesAutoresizingMaskIntoConstraints = false
        viewedTableView.dataSource = self
        viewedTableView.delegate = self
        viewedTableView.rowHeight = 200
        viewedTableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.identifier)
        return viewedTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(viewedTableView)
        NSLayoutConstraint.activate([
            viewedTableView.topAnchor.constraint(equalTo: view.topAnchor),
            viewedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

extension ViewedVideoViewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

extension ViewedVideoViewViewController: UITableViewDelegate {
    
}
