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
        self.canvas = [Location]()
        let noPixelsWide = width/pixelSize
        let noPixelsHigh = height/pixelSize
        for _ in 0..<noPixelsWide*noPixelsHigh {
            let location = Location()
            canvas.append(location)
        }
        
    }
    
    func getLocation(x: Int, y: Int) -> Location {
        
        let noPixelsWide = width/pixelSize
        
        let noPixelsInXDirection = x/pixelSize
        let noPixelsInYDirection = y/pixelSize
        
        let index = noPixelsInYDirection*noPixelsWide + noPixelsInXDirection
        
        return canvas[index]
        
    }
    
}
