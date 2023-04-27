//
//  DescriptionViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 26.04.2023.
//

import UIKit

final class DescriptionViewController: UIViewController {
    
    private lazy var descriptionTableView: UITableView = {
        let descriptionTableView = UITableView(frame: .zero, style: .insetGrouped)
        descriptionTableView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
        return descriptionTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
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
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}

extension DescriptionViewController: UITableViewDelegate {
    
}
