//
//  Pixel.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import Foundation
import UIKit

/* A representation of a pixel in relation to art that is to be depicted in the drawing editor. */
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

