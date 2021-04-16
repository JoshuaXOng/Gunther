//
//  CanvasView.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import UIKit

class CanvasView: UIView {
    
    var previousStroke: [CGPoint]?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.strokePath()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

}
