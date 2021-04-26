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
    
    init(name: String, height: Int, width: Int, pixelSize: Int, image: UIImage) {
        
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
        
        for i in 0..<noPixelsHigh {
            for j in 0..<noPixelsWide {
                let x = j*pixelSize
                let y = i*pixelSize
                //let pixelCenterPoint = Art.pixelCenter(pixelTLX: x, pixelTLY: y, pixelSize: pixelSize)
                // Code from: https://www.hackingwithswift.com/example-code/media/how-to-read-the-average-color-of-a-uiimage-using-ciareaaverage
                guard let ciImage = CIImage(image: image) else { return }
                let extentVector = CIVector(x: CGFloat(x), y: CGFloat(y), z: CGFloat(pixelSize), w: CGFloat(pixelSize))
                guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: ciImage, kCIInputExtentKey: extentVector]) else {
                    return
                }
                guard let outputImage = filter.outputImage else { return }
                var bitmap = [UInt8](repeating: 0, count: 4)
                let context = CIContext(options: [.workingColorSpace: kCFNull])
                context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
                let uiColor = UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
                
                let noPixelsInXDirection = x/pixelSize
                let noPixelsInYDirection = y/pixelSize
                let index = noPixelsInYDirection*noPixelsWide + noPixelsInXDirection
                canvas[index].clear()
                let p = Pixel(color: uiColor.cgColor)
                canvas[index].push(pixel: p)
                
                print("oh")
                
            }
        }
    }
    
    // Sort Coords class scope out -- this function should be temp for now
    static func pixelCenter(pixelTLX: Int, pixelTLY: Int, pixelSize: Int) -> CGPoint {
        let pixelCenterX = pixelTLX + pixelSize/2
        let pixelCenterY = pixelTLY + pixelSize/2
        return CGPoint(x: pixelCenterX, y: pixelCenterY)
    }
    
    func getLocation(x: Int, y: Int) -> Location {
        
        let noPixelsWide = width/pixelSize
        
        let noPixelsInXDirection = x/pixelSize
        let noPixelsInYDirection = y/pixelSize
        
        let index = noPixelsInYDirection*noPixelsWide + noPixelsInXDirection
        
        return canvas[index]
        
    }
    
    /*
    func placePixel(x: Int, y: Int, r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> bool {
        let location = getLocation(x: x, y: y)
        let pixel = Pixel(r: r, g: g, b: b, a: a)
        location.push(pixel)
    }
    */
    
}
