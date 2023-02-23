//
//  MainlCollectionViewCell.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 23.02.2023.
//

import UIKit

final class MainlCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cell() {
        contentView.backgroundColor = .blue
    }
}
