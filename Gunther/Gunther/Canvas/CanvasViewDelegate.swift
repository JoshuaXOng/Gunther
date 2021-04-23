//
//  CanvasViewDelegate.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import Foundation
import UIKit

protocol CanvasViewDelegate {
    
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    
}
