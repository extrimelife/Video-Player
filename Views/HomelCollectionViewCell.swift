//
//  MainlCollectionViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 23.02.2023.
//

import UIKit

class HomelCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
     
    private var userActionModel: UserAction!
    private var favoriteStatus = false
    
    private let homeImageview: UIImageView = {
        let homeImageView = UIImageView()
        homeImageView.translatesAutoresizingMaskIntoConstraints = false
        homeImageView.contentMode = .scaleAspectFill
        homeImageView.layer.cornerRadius = 10
        homeImageView.clipsToBounds = true
        return homeImageView
    }()
    
    private let homeLabel: UILabel = {
        let homeLabel = UILabel()
        homeLabel.translatesAutoresizingMaskIntoConstraints = false
        homeLabel.numberOfLines = 0
        homeLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        homeLabel.textColor = .black
        return homeLabel
    }()
    
    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton(type: .custom)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favoriteButton.tintColor = .systemGray4
        favoriteButton.addTarget(self, action: #selector(tapGesture), for: .touchUpInside)
        return favoriteButton
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
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
        homeLabel.text = categories.title
        imageUrl = URL(string: categories.thumb)
        guard let imageUrl = imageUrl else { return }
        NetworkManager.share.fetchImage(from: imageUrl) { [unowned self] result in
            if imageUrl == self.imageUrl {
                switch result {
                case .success(let image):
                    homeImageview.image = UIImage(data: image)
                    activityIndicator.stopAnimating()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    @objc private func tapGesture(sender: UIButton) {
        favoriteStatus.toggle()
        sender.tintColor = favoriteStatus ? .systemRed : .systemGray4
    }
    
    
    private func setupLayout() {
        [homeImageview, homeLabel, favoriteButton, activityIndicator] .forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            homeImageview.topAnchor.constraint(equalTo: contentView.topAnchor),
            homeImageview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            homeImageview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            homeImageview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            homeLabel.topAnchor.constraint(equalTo: homeImageview.bottomAnchor, constant: 5),
            homeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            homeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            favoriteButton.topAnchor.constraint(equalTo: homeImageview.topAnchor, constant: 5),
            favoriteButton.trailingAnchor.constraint(equalTo: homeImageview.trailingAnchor, constant: -5),
            
            activityIndicator.centerXAnchor.constraint(equalTo: homeImageview.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: homeImageview.centerYAnchor)
        ])
    }
}

