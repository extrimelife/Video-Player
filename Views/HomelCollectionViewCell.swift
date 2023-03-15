//
//  MainlCollectionViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 23.02.2023.
//

import UIKit

final class HomelCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private let homeImageview: UIImageView = {
        let homeImageView = UIImageView()
        homeImageView.translatesAutoresizingMaskIntoConstraints = false
        return homeImageView
    }()
    
    private var imageUrl: URL? {
        didSet {
            homeImageview.image = nil
        }
    }
    
    // MARK: - Override Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(categories: Video) {
        imageUrl = URL(string: categories.thumb)
        guard let imageUrl = imageUrl else { return }
        NetworkManager.share.fetchImage(from: imageUrl) { [unowned self] result in
            if imageUrl == self.imageUrl {
                switch result {
                case .success(let image):
                    homeImageview.image = UIImage(data: image)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        contentView.addSubview(homeImageview)
        NSLayoutConstraint.activate([
            homeImageview.topAnchor.constraint(equalTo: contentView.topAnchor),
            homeImageview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            homeImageview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            homeImageview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

