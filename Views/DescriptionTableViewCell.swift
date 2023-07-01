//
//  DescriptionTableViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 30.06.2023.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {
    
    private lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
       // stackView.spacing = 100
        return stackView
    }()
    
    let descriptionImage: UIImageView = {
        let descriptionImage = UIImageView()
        descriptionImage.translatesAutoresizingMaskIntoConstraints = false
        descriptionImage.contentMode = .scaleAspectFill
        descriptionImage.layer.cornerRadius = 10
        descriptionImage.clipsToBounds = true
        return descriptionImage
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(video: Mask) {
        descriptionImage.image = UIImage(data: video.image ?? Data())
        titleLabel.text = video.title
        descriptionLabel.text = video.descriptio
    }
    
    private func setupLayout() {
        contentView.addSubview(detailsStackView)
        [descriptionImage, titleLabel, separator, descriptionLabel] .forEach { detailsStackView.addArrangedSubview($0) }
        NSLayoutConstraint.activate([
            descriptionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionImage.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16),
            descriptionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            //titleLabel.topAnchor.constraint(equalTo: descriptionImage.bottomAnchor, constant: 30),
            
            separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 100),
            
            descriptionLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
