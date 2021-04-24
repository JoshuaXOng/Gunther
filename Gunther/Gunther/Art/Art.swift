//
//  Art.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import UIKit

class Art: NSObject {
    
    var name: String
    var height: Int
    var width: Int
    var pixelSize: Int
    var canvas: [Location]
    
    init(name: String, height: Int, width: Int, pixelSize: Int) {
        
        self.name = name
        self.height = height
        self.width = width
        self.pixelSize = pixelSize
        
        // Given the height, width and pixelSize, the locations should have inherent coordinates.
        let noPixelsWide = width/pixelSize
        let notPixelHigh = height/pixelSize
        self.canvas = [Location]()
        for _ in 0..<noPixelsWide*notPixelHigh {
            let location = Location()
            canvas.append(location)
        }
        
    }
    
    func getLocation(x: Float, y: Float) -> Location {
        let xRounded = x.rounded(.down)
        let yRounded = y.rounded(.down)
        let index = Int(yRounded)*width+Int(xRounded)
        return canvas[index]
    }
    
}
