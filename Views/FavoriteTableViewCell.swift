//
//  FavoriteTableViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 04.03.2023.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell {
    
    //MARK: - Public Properties
    
    weak var delegateFBDeselect: DeselectStatusDelegate!
    
    // MARK: - Private Properties
    
    private var favoriteStatus = false
    
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
    
    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton(type: .custom)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.tintColor = .red
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(tapGesture), for: .touchUpInside)
        return favoriteButton
    }()
    
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
        favoriteLabel.text = categories.title
        favoriteImageView.image = UIImage(data: categories.image ?? Data())
        
    }
    
    // MARK: - Private Methods
    
    @objc private func tapGesture(sender: UIButton) {
        favoriteStatus.toggle()
        if favoriteStatus {
            delegateFBDeselect.favoriteStatusDelete()
        }
    }
    
    private func setupLayout() {
        [favoriteImageView, favoriteLabel, favoriteButton] .forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            favoriteImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            favoriteImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            favoriteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: favoriteImageView.topAnchor, constant: 5),
            favoriteButton.trailingAnchor.constraint(equalTo: favoriteImageView.trailingAnchor, constant: -5),
            
            favoriteLabel.topAnchor.constraint(equalTo: favoriteImageView.bottomAnchor),
        ])
    }
}

