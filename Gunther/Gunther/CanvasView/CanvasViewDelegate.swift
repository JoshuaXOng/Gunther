//
//  CanvasViewDelegate.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import Foundation
import UIKit

protocol CanvasViewDelegate {
    var art: Art? {get set}
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    //func onTouchesEnded... Use to have redo/undo functionality...
}
