//
//  Location.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import Foundation

/* A representation of a location on the canvas of an art in relation to the drawing editor. */
class Location {
    
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
        let lastElement = self.content.removeLast()
        self.content = [lastElement]
    }
    
    func peek() -> Pixel? {
        return self.content.last
    }
    
    func clear() {
        self.content = [Pixel]()
    }
    
    func copy() -> Location {
        let locationCopy = Location()
        locationCopy.content = self.content.map { $0.copy() }
        return locationCopy
    }
    
}


