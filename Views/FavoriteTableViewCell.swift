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
        favoriteImage.layer.cornerRadius = 10
        favoriteImage.clipsToBounds = true
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
    
    func configurateCell(categories: Mask) {
        favoriteLabel.text = categories.text
       
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        [favoriteImageView, favoriteLabel] .forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            favoriteImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            favoriteImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            favoriteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            favoriteLabel.topAnchor.constraint(equalTo: favoriteImageView.bottomAnchor),
        ])
    }
}
