//
//  UIView + Extension.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 03.06.2023.
//

import UIKit

extension UIView {
    
    func addShadow() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        layer.shadowRadius = 17.0
        layer.shadowOpacity = 1
        layer.cornerRadius = 10
    }
}
