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
    var noGuntherPixelsHigh: Int
    var noGuntherPixelsWide: Int
    var pixelSize: Int
    var canvas: [Location]
        
    init(name: String, height: Int, width: Int, pixelSize: Int) {
        
        self.name = name
        self.height = height
        self.width = width
        self.noGuntherPixelsHigh = height/pixelSize
        self.noGuntherPixelsWide = width/pixelSize
        self.pixelSize = pixelSize
        
        // Given the height, width and pixelSize, the locations should have inherent coordinates.
        self.canvas = [Location]()
        let noPixelsWide = width/pixelSize
        let noPixelsHigh = height/pixelSize
        for _ in 0 ..< noPixelsWide*noPixelsHigh {
            let location = Location()
            canvas.append(location)
        }
        
        super.init()
        
    }
    
    convenience init(name: String, height: Int, width: Int, pixelSize: Int, image: UIImage) {
        self.init(name: name, height: height, width: width, pixelSize: pixelSize)
        updateCanvasFromImage(image: image)
    }
    
    private func updateCanvasFromImage(image: UIImage) {
        
        /*
        CODE FROM: https://www.ralfebert.de/ios/examples/image-processing/uiimage-raw-pixels/
        Used to access the raw pixels of a UIImage
        */
        
        guard let cgImage = image.cgImage, let data = cgImage.dataProvider?.data, let bytes = CFDataGetBytePtr(data) else {
            fatalError("Couldn't access image data")
        }
        assert(cgImage.colorSpace?.model == .rgb)

        let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
        for guntherY in 0 ..< noGuntherPixelsHigh {
            for guntherX in 0 ..< noGuntherPixelsWide {
                
                let y = (guntherY*pixelSize)+(pixelSize/2) // Sample the center of the Gunther pixel, not the extremities, to prevent blurring
                let x = (guntherX*pixelSize)+(pixelSize/2)
                let offset = (y * cgImage.bytesPerRow) + (x * bytesPerPixel)
                let b = CGFloat(bytes[offset])/255.0 // Without the CGFloat cast and '.0', the result rounds itself to the nearest int
                let g = CGFloat(bytes[offset+1])/255.0
                let r = CGFloat(bytes[offset+2])/255.0
                let a = CGFloat(bytes[offset+3])/255.0
                let color = CGColor(red: r, green: g, blue: b, alpha: a)
                
                let index = guntherY*noGuntherPixelsWide+guntherX
                canvas[index].clear()
                canvas[index].push(pixel: Pixel(color: color))
                
            }
        }
        
    }
    
    func getLocation(x: Int, y: Int) throws -> Location {
        
        if width <= x || x < 0 || height <= y || y < 0 {
            throw ArtExceptions.outOfBoundsError("The coords provided is out of the canvas' bounds")
        }
        
        let guntherX = x/pixelSize
        let guntherY = y/pixelSize
        let index = guntherY*noGuntherPixelsWide + guntherX
        return canvas[index]
        
    }
    
    func getLocation(guntherX: Int, guntherY: Int) throws -> Location {
        
        if noGuntherPixelsWide <= guntherX || guntherX < 0 || noGuntherPixelsHigh <= guntherY || guntherY < 0 {
            throw ArtExceptions.outOfBoundsError("The coords provided is out of the canvas' bounds")
        }
        
        let index = guntherY*noGuntherPixelsWide + guntherX
        return canvas[index]
        
    }
    
    func drawToContext(graphicsContext: CGContext) {
        
        for index in 0 ..< canvas.count {
            
            let x = (index*pixelSize)%width
            let y = ((index*pixelSize-x)/width)*pixelSize
            
            do  {
                let location = try getLocation(x: x, y: y)
                var color: CGColor = UIColor.white.cgColor
                if !location.content.isEmpty {
                    color = location.peek()!.color
                }
                graphicsContext.setFillColor(color)
                
                graphicsContext.fill(CGRect(x: x, y: y, width: pixelSize, height: pixelSize))
            }
            catch { continue }
            
         }
     
     }
    
    func getPNGData() -> Data? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        let image = renderer.image { rendererContext in
            self.drawToContext(graphicsContext: rendererContext.cgContext)
        }
        return image.pngData()
    }
    
    func copy() -> Art {
        let artCopy = Art(name: self.name, height: self.height, width: self.width, pixelSize: self.pixelSize)
        artCopy.noGuntherPixelsWide = self.noGuntherPixelsWide
        artCopy.noGuntherPixelsHigh = self.noGuntherPixelsHigh
        artCopy.canvas = self.canvas.map { $0.copy() }
        return artCopy
    }
    
}


