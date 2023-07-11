//
//  DescriptionTableViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 30.06.2023.
//

import UIKit

final class DescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let descriptionImage: UIImageView = {
        let descriptionImage = UIImageView()
        descriptionImage.translatesAutoresizingMaskIntoConstraints = false
        descriptionImage.contentMode = .scaleAspectFill
        descriptionImage.layer.cornerRadius = 10
        descriptionImage.clipsToBounds = true
        return descriptionImage
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return descriptionLabel
    }()
    
    
    //MARK: - Override Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    
    func configureCell(video: Mask) {
        descriptionImage.image = UIImage(data: video.image ?? Data())
        titleLabel.text = video.title
        descriptionLabel.text = video.descriptio
    }
    
    //MARK: - Private Methods
    
    private func setupLayout() {
        contentView.addSubview(detailsStackView)
        [descriptionImage, titleLabel, separator, descriptionLabel] .forEach { detailsStackView.addArrangedSubview($0) }
        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            detailsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            detailsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -120),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            descriptionImage.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
}
