//
//  File.swift
//  Gunther
//
//  Created by user184453 on 4/26/21.
//

import Foundation
import UIKit

class Coords {
    
    static func pixelCenter(pixelTLX: Int, pixelTLY: Int, pixelSize: Int) -> CGPoint {
        let pixelCenterX = pixelTLX + pixelSize/2
        let pixelCenterY = pixelTLY + pixelSize/2
        return CGPoint(x: pixelCenterX, y: pixelCenterY)
    }
    
}
