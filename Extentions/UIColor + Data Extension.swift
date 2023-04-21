//
//  NSColor.swift
//  MeTube Pet
//
//  Created by roman Khilchenko on 19.04.2023.
//

import UIKit

extension UIColor {
        
     func color(data: Data) -> UIColor? {
          return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
     }

     func encode() -> Data? {
          return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
     }
}

