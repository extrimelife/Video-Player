//
//  Empty.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 22.05.2023.
//

import UIKit

final class EmptyView: UIView {
    
    // MARK: - Private Properties
    
    private var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = -20
        return stackView
    }()
    
    private var emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Override Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func show(title: String, image: UIImage) {
        titleLabel.text = title
        emptyImage.image = image
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
    
    // MARK: - Private Methods
    
    private func configureSubviews() {
        addSubview(totalStackView)
        [emptyImage, titleLabel] .forEach { totalStackView.addArrangedSubview($0) }
        NSLayoutConstraint.activate([
            totalStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            totalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
