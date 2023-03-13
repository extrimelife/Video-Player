//
//  MainlCollectionViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 23.02.2023.
//

import UIKit

final class HomelCollectionViewCell: UICollectionViewCell {
    
    private let collectionImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cell() {
        
    }
    
    private func setupLayout() {
        contentView.addSubview(collectionImageView)
        NSLayoutConstraint.activate([
            collectionImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
