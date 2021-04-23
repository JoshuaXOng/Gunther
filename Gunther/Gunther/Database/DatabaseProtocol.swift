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
    
    case category
    case userArt
    case all
    
}

protocol DatabaseListener: AnyObject {
    
    var listenerType: ListenerType {get set}
    func onCategoryChange(change: DatabaseChange, categories: [Category])
    func onUserArtChange(change: DatabaseChange, user: User)
    
}

protocol DatabaseProtocol: AnyObject {
    
    func cleanup()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func fetchAllCategories() -> [Category]
    
    //func addArtToCategory(category: Category, art: Art) -> Bool
    //func removeArtFromCategory(category: Category, art: Art) -> Bool
    func fetchAllArtFromCategory(category: Category) -> Bool
    
    func addUser(name: String) -> User
    func removeUser(user: User)
    func fetchAllUsers() -> [User]
    
    //func addArtToUser(user: User, art: Art) -> Bool
    //func removeArtFromUser(user: User, art: Art) -> Bool
    func fetchAllArtFromUser(user: User) -> Bool
    
}

