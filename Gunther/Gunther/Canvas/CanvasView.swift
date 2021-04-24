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
    
    init(width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x: 5, y: 100, width: width, height: height))
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
            
            let y = Int(Float(i/art.width).rounded(.down))
            let x = i-Int(y)*art.width
            
            let location = art.getLocation(x: x, y: y)
            var color: CGColor
            if !location.content.isEmpty {
                
            }
            else {
                color = UIColor.white.cgColor
            }
            context.setFillColor(color)
            
            context.fill(CGRect(x: x, y: y, width: art.pixelSize, height: art.pixelSize))
            
        }
        
    }
    
    // MARK: - Handle touch input
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvasViewDelegate?.onTouchesMoved(touches, with: event)
        setNeedsDisplay()
    }

}


