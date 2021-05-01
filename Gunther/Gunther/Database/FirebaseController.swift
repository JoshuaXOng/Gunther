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
            self.userRef = self.firestore.collection("Users").document("FnRAR2gPt6sprPdfTEN3")
            self.setupUserListener()
            self.setupCategoriesListener()
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
        guard let categoryID = category.id else {
            return false
        }
        categoriesRef?.document(categoryID).updateData(["artworks" : FieldValue.arrayUnion([art])])
        return true
    }
    
    func removeArtFromCategory(category: Category, art: SavedArt) -> Bool {
        guard let categoryID = category.id else { return false }
        categoriesRef?.document(categoryID).updateData(["artworks": FieldValue.arrayRemove([art])])
        return true
    }
    
    func addArtToUser(user: User, art: SavedArt) -> Bool {
        userRef?.updateData(["artworks" : FieldValue.arrayUnion([[
            "id": art.id,
            "name": art.name,
            "source": art.source,
            "width": art.width,
            "height": art.height,
            "pixelSize": art.pixelSize
        ]])])
        return true
    }
    
    func removeArtFromUser(user: User, art: SavedArt) -> Bool {
        userRef?.updateData(["artworks": FieldValue.arrayRemove([[
            "id": art.id,
            "name": art.name,
            "source": art.source,
            "width": art.width,
            "height": art.height,
            "pixelSize": art.pixelSize
        ]])])
        return true
    }
    
    // MARK: - Firebase Controller Specific Methods
     
    func setupCategoriesListener() {
        
        categoriesRef = firestore.collection("Categories")
        categoriesRef?.addSnapshotListener() { (querySnapshot, error) in
                    
            guard let querySnapshot = querySnapshot else {
                print("Yikes! Error fetching categories: \(String(describing: error))")
                return
            }
                    
            self.parseCategoriesSnapshot(snapshot: querySnapshot)
                
        }
        
    }
    
    func setupUserListener() {
        userRef?.addSnapshotListener() { (documentSnapshot, error) in
            guard let documentSnapshot = documentSnapshot else {
                print("Yikes. Failed to fetch document with error: \(String(describing: error))")
                return
            }
            self.parseUserSnapshot(snapshot: documentSnapshot)
        }
    }
    
    func parseCategoriesSnapshot(snapshot: QuerySnapshot) {
        
        snapshot.documentChanges.forEach { change in
            
            var parsedCategory: Category?
            
            do {
                parsedCategory = try change.document.data(as: Category.self)
            }
            catch {
                print("Unable to decode category: \(error)")
                return
            }
            
            guard let category = parsedCategory else {
                print("Document doesn't exist")
                return
            }
            
            if change.type == .added {
                categories.insert(category, at: Int(change.newIndex))
            }
            else if change.type == .modified {
                categories[Int(change.oldIndex)] = category
            }
            else if change.type == .removed {
                categories.remove(at: Int(change.oldIndex))
            }
            
            listeners.invoke { listener in
                if listener.listenerType == ListenerType.categories || listener.listenerType == ListenerType.all {
                    listener.onCategoriesChange(change: .update, categories: self.categories)
                }
            }
            
        }
        
    }
    
    func parseUserSnapshot(snapshot: DocumentSnapshot) {
        
        if !snapshot.exists {
            print("The document does not exist")
            return
        }
        
        do {
            
            guard let updatedUser = try snapshot.data(as: User.self) else {
                print("The user document does not exist.")
                return
            }
            self.user = updatedUser
        
        }
        catch {
            print("The user document cannot be decoded \(error)")
            return
        }
                    
        listeners.invoke { listener in
            if listener.listenerType == ListenerType.user || listener.listenerType == ListenerType.all {
                listener.onUserChange(change: .update, user: self.user)
            }
        }
                
    }

}


