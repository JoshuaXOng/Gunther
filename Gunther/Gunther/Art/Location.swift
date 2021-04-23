//
//  Location.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import Foundation

class Location {
    // Might want to add validation.
    
    var content: [Pixel]
    
    init() {
        self.content = [Pixel]()
    }
    
    func push(pixel: Pixel) {
        self.content.append(pixel)
    }
    
    func pop() throws {
        self.content.removeLast()
    }
    
    func squash() {
        let le = self.content.removeLast()
        self.content = [le]
    }
    
    func clear() {
        self.content = [Pixel]()
    }
    
}
