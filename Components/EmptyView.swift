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
        stackView.alignment = .center
        return stackView
    }()
    
    private var emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.setContentHuggingPriority(.required, for: .vertical)
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.tintColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - LifeCicle Override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func configureSubviews() {
        addSubview(totalStackView)
        [emptyImage, titleLabel] .forEach { totalStackView.addArrangedSubview($0) }
    }
    
    private func setupLayout() {
        totalStackView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        totalStackView.center = self.center
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
}
