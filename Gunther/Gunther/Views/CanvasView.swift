//
//  CanvasView.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import UIKit

class CanvasView: UIView {
    
    //every imported image might have to be pooled and re-pixelized
    //You can have a variable that hold the past 10 states of the canvas...
    var canvas: [[CGColor]]?
    
    var canvasPixelWidth: CGFloat?
    var canvasPixelHeight: CGFloat?
    var PIXEL_SIZE: CGFloat = 4 //relates to the the max resolution. dif from brush size - PS or bigger
    
    var isEditting: Bool = true
    var brushSize: CGFloat = 12
    var brushColor: CGColor?
    var strokes: [[CGPoint]?]?
    var currentStroke: [CGPoint]?
    
    //should have a delegate... Maybe not...
    //var canvasViewDelegate: CanvasViewDelegate?
    
    //https://forums.swift.org/t/how-do-i-code-pixel-colors-in-a-uiview-using-swift-maybe-metal-for-ios-iphone/10963    
    init(width: CGFloat, height: CGFloat) {
        
        self.canvasPixelWidth = round(width/PIXEL_SIZE)
        self.canvasPixelHeight = round(height/PIXEL_SIZE)
        
        let roundedWidth = self.canvasPixelWidth! * PIXEL_SIZE
        let roundedHeight = self.canvasPixelHeight! * PIXEL_SIZE
        
        super.init(frame: CGRect(x: 5, y: 100, width: roundedWidth, height: roundedHeight))
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    
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
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        for y in stride(from: 0, to: rect.height, by: PIXEL_SIZE) {
            for x in stride(from: 0, to: rect.width, by: PIXEL_SIZE) {
                var color = UIColor.white
                if (y/PIXEL_SIZE+x/PIXEL_SIZE) / 2 == round((y/PIXEL_SIZE+x/PIXEL_SIZE) / 2) {
                    color = UIColor.gray.withAlphaComponent(0.2)
                }
                context.setFillColor(color.cgColor)
                context.fill(CGRect(x: x, y: y, width: PIXEL_SIZE, height: PIXEL_SIZE))
            }
        }
        
        guard let currentStroke = currentStroke else { return }
        for point in currentStroke {
            guard let color = brushColor else { return }
            context.setFillColor(color)
            let x = round(point.x/PIXEL_SIZE)*PIXEL_SIZE
            let y = round(point.y/PIXEL_SIZE)*PIXEL_SIZE
            context.fill(CGRect(x: x, y: y, width: brushSize, height: brushSize))
        }
        
    }
    
    // MARK: - Handle touch input
    
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


