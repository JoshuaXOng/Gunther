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
    var user: User
    
    // References to Firebase services and entities.
    var authController: Auth
    var firestore: Firestore
    var storage: Storage
    var categoriesRef: CollectionReference?
    var userRef: DocumentReference?
    var savedArtRef: CollectionReference
    
    override init() {
        
        FirebaseApp.configure()
        authController = Auth.auth()
        firestore = Firestore.firestore()
        storage = Storage.storage()
        savedArtRef = firestore.collection("Artworks")
        
        categories = [Category]()
        user = User()

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
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        let listenerType = listener.listenerType
        if listenerType == .categories || listenerType == .all {
            listener.onCategoriesChange(change: .update, categories: categories)
        }
        else if listenerType == .user || listenerType == .all {
            listener.onUserChange(change: .update, user: user)
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func addArtToCategory(category: Category, art: SavedArt) -> Bool {
        
        guard let categoryID = category.id, let artID = art.id else {
            return false
        }
                
        let newSavedArtRef = savedArtRef.document(artID)
        categoriesRef?.document(categoryID).updateData(["artworks" : FieldValue.arrayUnion([newSavedArtRef])])
        return true
        
    }
    
    func removeArtFromCategory(category: Category, art: SavedArt) -> Bool {
        if category.artworks.contains(art), let categoryID = category.id, let artID = art.id {
            let removedArtRef = savedArtRef.document(artID)
            categoriesRef?.document(categoryID).updateData(["artworks": FieldValue.arrayRemove([removedArtRef])])
            return true
        }
        return false
    }
    
    func addArtToUser(user: User, art: SavedArt) -> Bool {
    
        guard let artID = art.id else {
            return false
        }
                
        let newSavedArtRef = savedArtRef.document(artID)
        userRef?.updateData(["artworks" : FieldValue.arrayUnion([newSavedArtRef])])
        return true
        
    }
    
    func removeArtFromUser(user: User, art: SavedArt) -> Bool {
        if user.artworks.contains(art), let artID = art.id {
            let removedArtRef = savedArtRef.document(artID)
            userRef?.updateData(["artworks": FieldValue.arrayRemove([removedArtRef])])
            return true
        }
        return false
    }
    
    // MARK: - Firebase Controller Specific Methods
    
    /*func getHeroIndexByID(_ id: String) -> Int? {}
    func getHeroByID(_ id: String) -> SuperHero? {}
     
    func setupCategoriesListener() {}
    func setupUserListener() {}
    func parseCategoriesSnapshot(snapshot: QuerySnapshot) {}
    func parseUserSnapshot(snapshot: QueryDocumentSnapshot) {}*/

}
