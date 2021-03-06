//
//  CanvasView.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import Foundation
import UIKit

/*
 * Extends UIView, and acts as the direct 'view' of the editor's represenation of an artwork (i.e. the Art class).
 * As such, this class is responsible for handling touch input (whether it be through delegation) and presenting the artwork's
 * underlying representation.
 */
class CanvasView: UIView {
    
    var canvasViewDelegate: CanvasViewDelegate?
    
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
        
    }
    
    // MARK: - Handle touch input
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvasViewDelegate?.onTouchesMoved(touches, with: event)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canvasViewDelegate?.onTouchesEnded(touches, with: event)
    }

}


