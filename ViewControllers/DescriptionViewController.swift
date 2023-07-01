//
//  DescriptionViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 26.04.2023.
//

import UIKit

final class DescriptionViewController: UIViewController {
    
    private var descriptionVideo: [Mask] = []
    
    private lazy var descriptionTableView: UITableView = {
        let descriptionTableView = UITableView(frame: .zero, style: .insetGrouped)
        descriptionTableView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
        descriptionTableView.register(DescriptionTableViewCell.self, forCellReuseIdentifier: DescriptionTableViewCell.identifier)
        return descriptionTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        fetchData()
    }
    
    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let data):
                descriptionVideo = data
                descriptionTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(descriptionTableView)
        NSLayoutConstraint.activate([
            descriptionTableView.topAnchor.constraint(equalTo: view.topAnchor),
            descriptionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            descriptionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension DescriptionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        descriptionVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier, for: indexPath) as? DescriptionTableViewCell else { return DescriptionTableViewCell() }
        let descriptionVideo = descriptionVideo[indexPath.row]
        cell.configureCell(video: descriptionVideo)
        return cell
    }
}

extension DescriptionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
