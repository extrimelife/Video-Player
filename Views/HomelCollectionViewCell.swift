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
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    
    
    private var imageUrl: URL? {
        didSet {
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       setupLayout()
    }
    
    func configure(categories: Video) {
        NetworkManager.share.fetchImage(from: categories.thumb) { data in
            self.imageView.image = UIImage(data: data)
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

