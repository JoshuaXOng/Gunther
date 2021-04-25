//
//  FirebaseController.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import FirebaseStorageSwift

class FirebaseController: NSObject, DatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var categories: [Category]
    
    // References to Firebase services and entities.
    var authController: Auth
    var firestore: Firestore
    var storage: Storage
    var categoriesRef: CollectionReference?
    var usersRef: CollectionReference?
    
    override init() {
        
        FirebaseApp.configure()
        authController = Auth.auth()
        firestore = Firestore.firestore()
        storage = Storage.storage()
        categories = [Category]()

        super.init()
        
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase Auth failed with Error: \(String(describing: error))")
            }
            //self.setupHeroListener()
        }
        
    }
    
    // MARK: - Implement DatabaseProtocol
    
    func cleanup() {}
    
    func addListener(listener: DatabaseListener) {}
    func removeListener(listener: DatabaseListener) {}

    func fetchAllCategories() -> [Category] { return [Category]() }
    
    func addArtToCategory(category: Category, art: Art) -> Bool { return false }
    func removeArtFromCategory(category: Category, art: Art) -> Bool { return false }
    func fetchAllArtFromCategory(category: Category) -> [Art] { return [Art]() }
    
    func addArtToUser(user: User, art: Art) -> Bool { return false }
    func removeArtFromUser(user: User, art: Art) -> Bool { return false }
    func fetchAllArtFromUser(user: User) -> [Art] { [Art]() }
    
    // MARK: - Firebase Controller Specific Methods
    /*func getHeroIndexByID(_ id: String) -> Int? {}
    func getHeroByID(_ id: String) -> SuperHero? {}
    func setupHeroListener() {}
    func setupTeamListener() {}
    func parseHeroesSnapshot(snapshot: QuerySnapshot) {}
    func parseTeamSnapshot(snapshot: QueryDocumentSnapshot) {}*/

}
