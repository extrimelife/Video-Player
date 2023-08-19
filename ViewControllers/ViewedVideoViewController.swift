//
//  ViewedViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 22.06.2023.
//

import UIKit

class ViewedVideoViewController: UIViewController {
    
    var viewedVideo = [Mask]()
    
    lazy var viewedTableView: UITableView = {
        let viewedTableView = UITableView(frame: .zero, style: .insetGrouped)
        viewedTableView.translatesAutoresizingMaskIntoConstraints = false
        viewedTableView.dataSource = self
        viewedTableView.delegate = self
        viewedTableView.rowHeight = 200
        viewedTableView.register(ViewedTableViewCell.self, forCellReuseIdentifier: ViewedTableViewCell.identifier)
        return viewedTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
//        guard let navigationVC = tabBarController?.viewControllers?[1] as? UINavigationController else { return }
//        guard let favoriteVC = navigationVC.viewControllers[0] as? FavoriteViewController else { return }
//        favoriteVC.delegateReloadViewedVC = self
    }
    
    func getVideo(video: Mask) {
        viewedVideo.append(video)
        viewedTableView.reloadData()
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

extension ViewedVideoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewedVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ViewedTableViewCell.identifier, for: indexPath) as? ViewedTableViewCell else { return ViewedTableViewCell() }
        let viewedVideo = viewedVideo[indexPath.row]
        cell.configureCell(video: viewedVideo)
        return cell
    }
}

extension ViewedVideoViewController: UITableViewDelegate {
    
}
