//
//  DescriptionTableViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 30.06.2023.
//

import UIKit

final class DescriptionTableViewCell: UITableViewCell {
    
    //MARK: - Public Properties
    
    var butttonClicked: (() -> (Void))!
    
    lazy var wholeDescriptionButton: UIButton = {
        let wholeDescriptionButton = UIButton()
        wholeDescriptionButton.translatesAutoresizingMaskIntoConstraints = false
        wholeDescriptionButton.setTitleColor(UIColor(hexString: "#fc0303"), for: .normal)
        wholeDescriptionButton.setTitle("See More", for: .normal)
        wholeDescriptionButton.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
        return wholeDescriptionButton
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return descriptionLabel
    }()
    
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
    
    @objc private func tappedButton() {
        butttonClicked()
    }
    
    private func setupLayout() {
        contentView.addSubview(detailsStackView)
        [descriptionImage, titleLabel, separator, descriptionLabel, wholeDescriptionButton] .forEach { detailsStackView.addArrangedSubview($0) }
        NSLayoutConstraint.activate([
            detailsStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            detailsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            detailsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -120),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionImage.heightAnchor.constraint(equalToConstant: 200),
            
            wholeDescriptionButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            wholeDescriptionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 250)
           
        ])
    }
}
