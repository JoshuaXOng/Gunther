//
//  UIImage+Extensions.swift
//  Gunther
//
//  Created by user184453 on 4/29/21.
//

import Foundation
import UIKit

extension UIImage {
    
    /* CODE FROM: https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift#:~:text=Image%20resize%20function%20in%20swift%20as%20below.&text=swift3%20updated-,func%20resizeImage(image%3A%20UIImage%2C%20targetSize%3A%20CGSize)%20%2D,width%20%2F%20size.
    By user Kirit Modi
    */
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
}
