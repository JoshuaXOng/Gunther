//
//  ArtManager.swift
//  Gunther
//
//  Created by user184453 on 5/13/21.
//

import Foundation

/* Manages the versions of an artwork. In other words, implements undo/redo functionality. */
class ArtManager {
    
    private var pastArt = [Art]()
    private var currentArt: Art
    private var futureArt = [Art]()
    
    init(art: Art) {
        currentArt = art.copy()
    }
    
    public func update(updatedArt: Art) {
        pastArt.append(currentArt)
        currentArt = updatedArt.copy()
        futureArt = [Art]()
        truncatePast()
    }
    
    public func undo() -> Art {
        if hasPast() {
            futureArt.insert(currentArt, at: 0)
            currentArt = pastArt.popLast()!
            return currentArt.copy()
        }
        return currentArt.copy()
    }
    
    public func redo() -> Art {
        if hasFuture() {
            pastArt.append(currentArt)
            currentArt = futureArt.remove(at: 0)
            return currentArt.copy()
        }
        return currentArt.copy()
    }
    
    private func hasPast() -> Bool {
        return !pastArt.isEmpty
    }
    
    private func hasFuture() -> Bool {
        return !futureArt.isEmpty
    }
    
    private func truncatePast() {
        if pastArt.count > 5 {
            pastArt.remove(at: 0)
        }
    }
    
}
