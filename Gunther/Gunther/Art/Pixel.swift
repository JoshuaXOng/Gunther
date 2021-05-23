//
//  Pixel.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import Foundation
import UIKit

class Pixel {
    // Consider using straight r, g, b and a values for speed...

    var color: CGColor

    init(color: CGColor) {
        self.color = color
    }
    
    func copy() -> Pixel {
        return Pixel(color: self.color)
    }
    
}

