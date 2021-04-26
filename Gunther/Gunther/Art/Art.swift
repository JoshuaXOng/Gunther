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
    
    var test: UIImageView?
        
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
        
        
        test = UIImageView(image: image)
        
        // CODE NOT BY ME
        
        guard let cgImage = image.cgImage,
            let data = cgImage.dataProvider?.data,
            let bytes = CFDataGetBytePtr(data) else {
            fatalError("Couldn't access image data")
        }
        assert(cgImage.colorSpace?.model == .rgb)

        let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
        
        /*
        for i in 0 ..< (height*width){  //bytesPerPixel {
            print(bytes[i])
            // So it is b,g,r,a
            // And this is printing out right...
        }
        */
        
        for y in 0 ..< noPixelsHigh {
            for x in 0 ..< noPixelsWide {
                //let point = Art.pixelCenter(pixelTLX: x*pixelSize, pixelTLY: y*pixelSize, pixelSize: pixelSize)
                //print(point)
                let testY = y*pixelSize//Int(point.y)
                let testX = x*pixelSize//Int(point.x)
                let offset = (testY * cgImage.bytesPerRow) + (testX * bytesPerPixel)
                //let components = (r: bytes[offset], g: bytes[offset + 1], b: bytes[offset + 2], a: bytes[offset+3])
                //print("[x:\(x), y:\(y)] \(components)")
                let b = CGFloat(bytes[offset])/255.0 // FUUUUUUUUCKKKKKKK, RNDS TO INT
                let g = CGFloat(bytes[offset+1])/255.0
                let r = CGFloat(bytes[offset+2])/255.0
                let a = CGFloat(bytes[offset+3])/255.0
                /*
                if x == 0 && y == 0 {
                    print(r,g,b,a)
                    print(bytes[offset+2],bytes[offset+1],bytes[offset])
                    print(bytes[2],bytes[1],bytes[0],bytes[3])
                }
                */
                //print(r,g,b,a)
                let c = CGColor(red: r, green: g, blue: b, alpha: a)
                
                let i = y*noPixelsWide+x
                canvas[i].clear()
                let p = Pixel(color: c)
                canvas[i].push(pixel: p)
                
            }
            print("---")
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
