//
//  CanvasView.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import UIKit

class CanvasView: UIView {
    
    //You can have a variable that hold the past 10 states of the canvas...
    var strokes: [[CGPoint]?]?
    var currentStroke: [CGPoint]?
    
    //https://forums.swift.org/t/how-do-i-code-pixel-colors-in-a-uiview-using-swift-maybe-metal-for-ios-iphone/10963
    //Can use my own data structure -- matrix
    //Use in conjunciton with CGRectangle -- don't bother trying to expand bitmap...
    
    /*override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        /*
        guard let currentStroke = currentStroke else { return }
        for i in 0...currentStroke.count-1 {
            if i == 0 {
                context.move(to: currentStroke[i])
            }
            else {
                context.addLine(to: currentStroke[i])
            }
        }
         */
        context.move(to: CGPoint(x: 0, y: 100))
        context.addLine(to: CGPoint(x: 400, y: 150))
           
        context.strokePath()
        
        print(context.height)
        
    }*/
    
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
