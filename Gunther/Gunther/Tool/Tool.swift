//
//  File.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import Foundation

protocol Tool {
    var size: Int? {get set}
    func nibArea(x: Int, y: Int) -> [[Int]]?
}
