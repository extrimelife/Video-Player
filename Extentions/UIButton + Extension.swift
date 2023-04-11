//
//  UIButton + Extension.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 19.03.2023.
//

import UIKit

extension UIButton {
    
    func getAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.4
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1
            })
        }
    }
}
 

