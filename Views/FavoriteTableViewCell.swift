//
//  FavoriteTableViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 04.03.2023.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private let favoriteImageView: UIImageView = {
        let favoriteImage = UIImageView()
        favoriteImage.translatesAutoresizingMaskIntoConstraints = false
        favoriteImage.contentMode = .scaleAspectFill
        return favoriteImage
    }()
    
    private let favoriteLabel: UILabel = {
        let favoriteLabel = UILabel()
        favoriteLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return favoriteLabel
    }()
    
    private var imageUrl: URL? {
        didSet {
            favoriteImageView.image = nil
        }
    }
    
    // MARK: - Override Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configurateCell(categories: Video) {
        favoriteLabel.text = categories.title
        imageUrl = URL(string: categories.thumb)
        guard let imageUrl = imageUrl else { return }
        NetworkManager.share.fetchImage(from: imageUrl) { [unowned self] result in
            if imageUrl == self.imageUrl {
                switch result {
                case .success(let image):
                    favoriteImageView.image = UIImage(data: image)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        [favoriteImageView, favoriteLabel] .forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            favoriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            favoriteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            favoriteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            favoriteLabel.topAnchor.constraint(equalTo: favoriteImageView.bottomAnchor, constant: 5),
            favoriteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            favoriteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
