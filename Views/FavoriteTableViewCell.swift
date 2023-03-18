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
        [favoriteImageView] .forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            favoriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            favoriteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            favoriteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
