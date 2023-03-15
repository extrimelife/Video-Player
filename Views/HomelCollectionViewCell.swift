//
//  MainlCollectionViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 23.02.2023.
//

import UIKit

final class HomelCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var imageUrl: URL? {
        didSet {
            imageView.image = nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(categories: Video) {
        imageUrl = URL(string: categories.thumb)
        guard let imageUrl = imageUrl else { return }
        NetworkManager.share.fetchImage(from: imageUrl) { [unowned self] result in
            if imageUrl == self.imageUrl {
                switch result {
                case .success(let image):
                    imageView.image = UIImage(data: image)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

