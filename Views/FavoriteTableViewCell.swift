//
//  FavoriteTableViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 04.03.2023.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell {
    
    // MARK: Public Properties
    
    var getPlayButton: () -> () = {}
    var getReloadHomeVC: () -> () = {}
    
    // MARK: - Private Properties
    
    private var video: Mask!
    private lazy var isFavorite = false
    
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
        favoriteButton.tintColor = .systemGray2
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(tapGesture), for: .touchUpInside)
        return favoriteButton
    }()
    
    private lazy var playButton: UIButton = {
        let playButton = UIButton(type: .system)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setImage(UIImage(named: "Play"), for: .normal)
        playButton.tintColor = UIColor(hexString: "#f7f0f0")
        playButton.addTarget(self, action: #selector(playTapGesture), for: .touchUpInside)
        return playButton
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
        video = categories
        isFavorite = StorageManager.shared.checkMovieInCoreDataFor(id: categories.id ?? "")
        updateButtonState(isSelected: isFavorite)
        guard let categoriesURL = URL(string: categories.sources ?? "") else { return }
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let data):
                for mask in data {
                    if categoriesURL.lastPathComponent == mask.id {
                        favoriteButton.tintColor = .red
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getButtonTittle() {
        playButton.setImage(UIImage(named: "Play"), for: .normal)
    }
    
    // MARK: - Private Methods
    
    @objc private func tapGesture() {
        if isFavorite {
            guard let url = URL(string: video.sources ?? "") else { return }
            StorageManager.shared.removeFavoriteMovie(id: url.lastPathComponent)
            isFavorite = false
            updateButtonState(isSelected: false)
            getReloadHomeVC()
        } else {
            isFavorite = true
            updateButtonState(isSelected: true)
        }
    }
    
    private func updateButtonState(isSelected: Bool) {
        if isSelected {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = .red
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = .white
        }
    }
    
    @objc private func playTapGesture() {
        if playButton.currentImage == UIImage(named: "Play")  {
            playButton.setImage(UIImage(named: "Stop"), for: .normal)
            getPlayButton()
        }
    }
    
    private func setupLayout() {
        [favoriteImageView, favoriteLabel, favoriteButton, playButton] .forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            favoriteImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            favoriteImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            favoriteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: favoriteImageView.topAnchor, constant: 5),
            favoriteButton.trailingAnchor.constraint(equalTo: favoriteImageView.trailingAnchor, constant: -5),
            
            favoriteLabel.topAnchor.constraint(equalTo: favoriteImageView.bottomAnchor),
            
            playButton.centerXAnchor.constraint(equalTo: favoriteImageView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: favoriteImageView.centerYAnchor)
        ])
    }
}

