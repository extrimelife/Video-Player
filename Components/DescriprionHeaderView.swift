//
//  DescriprionHeaderViewController.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 11.07.2023.
//

import UIKit

final class DescriprionHeaderView: UIView {
    
    private let descriptionImage: UIImageView = {
        let descriptionImage = UIImageView()
        descriptionImage.translatesAutoresizingMaskIntoConstraints = false
        descriptionImage.image = UIImage(named: "HeaderImage")
       return descriptionImage
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(descriptionImage)
        self.addSubview(separator)
        NSLayoutConstraint.activate([
            descriptionImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            descriptionImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            descriptionImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            descriptionImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            separator.topAnchor.constraint(equalTo: descriptionImage.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 1)
            
        ])
    }
}
