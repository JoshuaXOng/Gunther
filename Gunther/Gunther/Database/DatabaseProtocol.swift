//
//  DatabaseProtocol.swift
//  FIT3178A2
//
//  Created by user184453 on 4/4/21.
//

import Foundation

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

    //func fetchAllCategories() -> [Category]
    
    func addArtToCategory(category: Category, art: Art) -> Bool
    func removeArtFromCategory(category: Category, art: Art) -> Bool
    
    func addArtToUser(user: User, art: Art) -> Bool
    func removeArtFromUser(user: User, art: Art) -> Bool
    //func fetchAllArtFromUser(user: User) -> [Art]
    
}

