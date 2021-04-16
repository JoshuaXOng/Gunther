//
//  CanvasView.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import UIKit

class CanvasView: UIView {
    
    var strokes: [[CGPoint]?]?
    var currentStroke: [CGPoint]?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
//        guard let currentStroke = currentStroke else { return }
//        for i in 0...currentStroke.count-1 {
//            if i == 0 {
//                context.move(to: currentStroke[i])
//            }
//            else {
//                context.addLine(to: currentStroke[i])
//            }
//        }
        
        context.move(to: CGPoint(x:0, y: 0))
        context.addLine(to: CGPoint(x: 200, y: 200))
        
        context.strokePath()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentStroke = []
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let fingerLocation = touches.first?.location(in: self) else { return }
        currentStroke?.append(fingerLocation)
        setNeedsDisplay()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        strokes?.append(currentStroke)
        currentStroke = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentStroke = nil
    }

}
