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
        
        art.drawToContext(graphicsContext: context)
        
        self.cgImageRep = context.makeImage()
        
    }
    
    // Have a function to draw art to a context -- i.e. drawArtToContext() -- maybe relocate this into Art aswell.
    // Then getPNGData() can also be relocated into Art.
    
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


