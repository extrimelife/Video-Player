//
//  MainlCollectionViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 23.02.2023.
//

import UIKit

final class HomelCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    var getPlayButton: () -> () = {}
    
    // MARK: - Private Properties
    
    private var isFavorite = false {
        didSet {
            updateButtonState(isSelected: isFavorite)
        }
    }
    
    private var video: Video!
    private var imageUrl: URL? {
        didSet {
            homeImageview.image = nil
        }
    }
    
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
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .black
        return descriptionLabel
    }()
    
    private let subTitle: UILabel = {
        let subTitle = UILabel()
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.numberOfLines = 0
        subTitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subTitle.textColor = .black
        return subTitle
    }()
    
    private let source: UILabel = {
        let source = UILabel()
        source.translatesAutoresizingMaskIntoConstraints = false
        source.numberOfLines = 0
        source.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        source.textColor = .black
        return source
    }()
    
    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton(type: .custom)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = .white
        favoriteButton.addTarget(self, action: #selector(tapGesture), for: .touchUpInside)
        return favoriteButton
    }()
    
    private lazy var playButton: UIButton = {
        let playButton = UIButton(type: .system)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setImage(UIImage(named: "Play2"), for: .normal)
        playButton.tintColor = UIColor(hexString: "#f7f0f0")
        playButton.addTarget(self, action: #selector(playTapGesture), for: .touchUpInside)
        return playButton
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
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
        source.text = categories.sources
        descriptionLabel.text = categories.description
        subTitle.text = categories.subtitle
        homeLabel.text = categories.title
        imageUrl = URL(string: categories.thumb)
        isFavorite = StorageManager.shared.checkMovieInCoreDataFor(id: categories.sources)
        guard let imageUrl = imageUrl else { return }
        NetworkManager.shared.fetchImage(from: imageUrl) { [unowned self] result in
            if imageUrl == imageUrl {
                switch result {
                case .success(let image):
                    homeImageview.image = UIImage(data: image)
                    activityIndicator.stopAnimating()
                case .failure(let error):
                    print(error)
                }
            }
        }
        video = categories
        guard let categoriesURL = URL(string: categories.sources) else { return }
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let data):
                for mask in data {
                    if categoriesURL.lastPathComponent == mask.id {
                        isFavorite.toggle()
                        favoriteButton.tintColor = isFavorite ? .red : .white
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getButtonTittle() {
        playButton.setImage(UIImage(named: "Play2"), for: .normal)
    }
    
    // MARK: - Private Methods
    
    @objc private func tapGesture() {
        if isFavorite {
            guard let url = URL(string: video.sources) else { return }
            StorageManager.shared.removeFavoriteMovie(id: url.lastPathComponent)
            isFavorite = false
            updateButtonState(isSelected: false)
        } else {
            StorageManager.shared.save(video: video, image: homeImageview.image?.pngData() ?? Data())
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
        if playButton.currentImage == UIImage(named: "Play2")  {
            playButton.setImage(UIImage(named: "Pause"), for: .normal)
            getPlayButton()
        }
    }
    
    private func setupLayout() {
        [homeImageview, playButton, homeLabel, favoriteButton, activityIndicator] .forEach { contentView.addSubview($0) }
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
            activityIndicator.centerYAnchor.constraint(equalTo: homeImageview.centerYAnchor),
            
            playButton.centerYAnchor.constraint(equalTo: homeImageview.centerYAnchor),
            playButton.centerXAnchor.constraint(equalTo: homeImageview.centerXAnchor)
            
        ])
    }
}
