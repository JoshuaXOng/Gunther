//
//  ArtManager.swift
//  Gunther
//
//  Created by user184453 on 5/13/21.
//

import Foundation

class ArtManager {
    
    private var pastArt = [Art]()
    private var currentArt: Art
    private var futureArt = [Art]()
    
    init(art: Art) {
        currentArt = art
    }
    
    public func update(updatedArt: Art) {
        pastArt.append(currentArt)
        currentArt = updatedArt
        futureArt = [Art]()
    }
    
    public func undo() -> Art? {
        if hasPast() {
            futureArt.insert(currentArt, at: 0)
            currentArt = pastArt.popLast()!
            return currentArt
        }
        return nil
    }
    
    public func redo() -> Art? {
        if hasFuture() {
            pastArt.append(currentArt)
            currentArt = futureArt.remove(at: 0)
            return currentArt
        }
        return nil
    }
    
    public func hasPast() -> Bool {
        return !pastArt.isEmpty
    }
    
    public func hasFuture() -> Bool {
        return !futureArt.isEmpty
    }
    
}
