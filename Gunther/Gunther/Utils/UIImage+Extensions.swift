//
//  UIImage+Extensions.swift
//  Gunther
//
//  Created by user184453 on 4/29/21.
//

import Foundation
import UIKit

extension UIImage {
    
    static func cropImage(image: UIImage, region: CGRect) -> UIImage? {
        
        guard let cgImage = image.cgImage,
              let croppedCGImage = cgImage.cropping(to: region) else {
            return nil
        }
        let image = UIImage(cgImage: croppedCGImage)
        
        assert((image.size.width == region.width) && (image.size.height == region.height), "Extension method cropImage() implementation is incorrect.")
        
        return image
        
    }
    
    /* CODE FROM: https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift#:~:text=Image%20resize%20function%20in%20swift%20as%20below.&text=swift3%20updated-,func%20resizeImage(image%3A%20UIImage%2C%20targetSize%3A%20CGSize)%20%2D,width%20%2F%20size.
    By user Kirit Modi
    */
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = CGSize(width: size.width * widthRatio,  height: size.height * heightRatio)

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
        
    }
    
}
