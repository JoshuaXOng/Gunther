//
//  DatabaseProtocol.swift
//  FIT3178A2
//
//  Created by user184453 on 4/4/21.
//

import Foundation
import UIKit

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case categories
    case user
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onCategoriesChange(change: DatabaseChange, categories: [Category])
    func onUserChange(change: DatabaseChange, user: User)
}

protocol DatabaseProtocol: AnyObject {
    
    func cleanup()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func addArtToCategory(category: Category, art: SavedArt) -> Bool
    func removeArtFromCategory(category: Category, art: SavedArt) -> Bool
    
    func addArtToUser(user: User, art: SavedArt) -> Bool
    func removeArtFromUser(user: User, art: SavedArt) -> Bool
    
    func copyArtFromUserToCategory(user: User, category: Category, artwork: SavedArt)
    func copyArtFromCategoryToUser(category: Category, user: User, artwork: SavedArt)
    
}

