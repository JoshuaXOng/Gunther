//
//  CanvasView.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import Foundation
import UIKit

class CanvasView: UIView {
    
    var canvasViewDelegate: CanvasViewDelegate?
    var cgImageRep: CGImage?
    
    init(width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext(), let canvasViewDelegate = canvasViewDelegate, let art = canvasViewDelegate.art else {
            return
        }
        
        for i in 0..<art.canvas.count {
            
            let noPixelsWide = art.width/art.pixelSize
            let y = Int(Float(i/noPixelsWide).rounded(.down))
            let x = i-Int(y)*noPixelsWide
            
            let location = art.getLocation(x: x*art.pixelSize, y: y*art.pixelSize)
            var color: CGColor = UIColor.white.cgColor
            if !location.content.isEmpty {
                color = location.peek()!.color
            }
            context.setFillColor(color)
            
            context.fill(CGRect(x: x*art.pixelSize, y: y*art.pixelSize, width: art.pixelSize, height: art.pixelSize))
            
        }
        
        self.cgImageRep = context.makeImage()
        
    }
    
    // Have a function to draw art to a context -- i.e. drawArtToContext()
    
    // MARK: - Handle touch input
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvasViewDelegate?.onTouchesMoved(touches, with: event)
        setNeedsDisplay()
    }
    
    // MARK: - Utilities
    
    func getPNGData() -> Data? {
        
        guard let cgImageRep = self.cgImageRep else { return nil }
        return UIImage(cgImage: cgImageRep).pngData()
        
    }

}


