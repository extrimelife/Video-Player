//
//  DescriptionTableViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 30.06.2023.
//

import UIKit

final class DescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    
    private var topDescriptionImage = NSLayoutConstraint()
    private var leadingDescriptionImage = NSLayoutConstraint()
    private var widthDescriptionImage = NSLayoutConstraint()
    private var heightDescriptionImage = NSLayoutConstraint()
    
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
    
    private let blackView: UIView = {
        let blackView = UIView()
        blackView.translatesAutoresizingMaskIntoConstraints = false
        blackView.alpha = 0
        blackView.backgroundColor = .black
        blackView.frame = UIScreen.main.bounds
        return blackView
    }()
    
    private lazy var crossButton: UIButton = {
        let crossButton = UIButton()
        crossButton.translatesAutoresizingMaskIntoConstraints = false
        crossButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        crossButton.tintColor = .systemGray4
        crossButton.alpha = 0
        crossButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return crossButton
    }()
    
    //MARK: - Override Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupGesture()
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
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTap))
        descriptionImage.isUserInteractionEnabled = true
        descriptionImage.addGestureRecognizer(tapGesture)
    }
    
    @objc private func actionTap() {
        addSubview(blackView)
        addSubview(crossButton)
        bringSubviewToFront(descriptionImage)
        
        NSLayoutConstraint.activate([
            crossButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            crossButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            crossButton.widthAnchor.constraint(equalToConstant: 30),
            crossButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [unowned self] in
            blackView.alpha = 0.8
            descriptionImage.layer.cornerRadius = 0
            topDescriptionImage.constant = 100
            leadingDescriptionImage.constant = 0
            widthDescriptionImage.constant = UIScreen.main.bounds.width
            heightDescriptionImage.constant = UIScreen.main.bounds.width
            layoutIfNeeded()
            
        } completion: { _ in
            UIView.animate(withDuration: 0.3) { [unowned self] in
                crossButton.alpha = 1
            }
        }
    }
    
    @objc private func cancelAction() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [unowned self] in
            crossButton.alpha = 0
            
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) { [unowned self] in
                descriptionImage.layer.cornerRadius = 10
                topDescriptionImage.constant = 0
                leadingDescriptionImage.constant = 16
                widthDescriptionImage.constant = 100
                heightDescriptionImage.constant = 200
                blackView.alpha = 0
                layoutIfNeeded()
            }
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(detailsStackView)
        [descriptionImage, titleLabel, separator, descriptionLabel] .forEach { detailsStackView.addArrangedSubview($0) }
        
        topDescriptionImage = descriptionImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16)
        leadingDescriptionImage = descriptionImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        widthDescriptionImage = descriptionImage.widthAnchor.constraint(equalToConstant: 100)
        heightDescriptionImage = descriptionImage.heightAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([
            topDescriptionImage,
            leadingDescriptionImage,
            widthDescriptionImage,
            heightDescriptionImage,
            detailsStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            detailsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            detailsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -120),
            separator.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
