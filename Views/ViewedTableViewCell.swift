//
//  ViewedTableViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 21.06.2023.
//

import UIKit

class ViewedTableViewCell: UITableViewCell {
    
    private let viewedImageview: UIImageView = {
        let viewedImageview = UIImageView()
        viewedImageview.translatesAutoresizingMaskIntoConstraints = false
        viewedImageview.contentMode = .scaleAspectFill
        viewedImageview.layer.cornerRadius = 10
        viewedImageview.clipsToBounds = true
        viewedImageview.backgroundColor = .red
        return viewedImageview
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return nameLabel
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCell(video: Mask) {
        viewedImageview.image = UIImage(data: video.image ?? Data())
        nameLabel.text = video.title
        
    }
    
    private func setupLayout() {
        [viewedImageview, nameLabel] .forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            viewedImageview.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewedImageview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewedImageview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            viewedImageview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: viewedImageview.bottomAnchor),
        ])
    }
}
