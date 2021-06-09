//
//  DatabaseProtocol.swift
//  FIT3178A2
//
//  Created by user184453 on 4/4/21.
//

import Foundation
import UIKit

/* Contains the available types of changes to the database. */
enum DatabaseChange {
    case add
    case remove
    case update
}

/*
 * Contains the available types of database listeners.
 * The value within this enum corresponds to what the
 * database listener should 'listen' to.
 */
enum ListenerType {
    case categories
    case user
    case all
}

/*
 * An interface for a database listener.
 * A database listener is simply a class that responds to changes in
 * the database.
 */
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onCategoriesChange(change: DatabaseChange, categories: [Category])
    func onUserChange(change: DatabaseChange, user: User)
}

/*
 * An interface for a database controller.
 */
protocol DatabaseProtocol: AnyObject {
    
    // To persistently save modifications to data in the database.
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

