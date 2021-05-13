//
//  Pixel.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import Foundation
import UIKit

class Pixel {
    // Consider using a struct for speed...
        
    // Refactor to contain straight r, g, b and a values
    var color: CGColor

    init(color: CGColor) {
        self.color = color
    }
    
}

extension Pixel {
    
    func copy() -> Pixel {
        return Pixel(color: self.color)
    }
    
}

