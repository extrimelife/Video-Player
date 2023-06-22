//
//  CoordinatManager.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 21.06.2023.
//

import UIKit

class CoordinatManager {
    
    let FavoriteVC: FavoriteViewController!
    
    init(FavoriteVC: FavoriteViewController!) {
        self.FavoriteVC = FavoriteVC
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
