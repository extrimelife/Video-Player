//
//  ImageCatchManager.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 15.03.2023.
//

import UIKit

final class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}

