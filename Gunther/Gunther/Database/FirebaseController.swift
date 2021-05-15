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
    var categories = [Category]()
    var user = User()
    
    // References to Firebase services and entities.
    var authController: Auth
    var firestore: Firestore
    var storage: Storage
    var categoriesRef: CollectionReference?
    var userRef: DocumentReference?
    
    override init() {
        
        FirebaseApp.configure()
        authController = Auth.auth()
        firestore = Firestore.firestore()
        storage = Storage.storage()
        
        super.init()
        
        authController.signInAnonymously() { (authResult, error) in
            guard authResult != nil else {
                fatalError("Firebase Auth failed with Error: \(String(describing: error))")
            }
            self.userRef = self.firestore.collection("Users").document("3TvMj0AkUw6BSRuFEW18")
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
    
    func fetchArtImageFromArt(art: SavedArt, completionHandler: @escaping (UIImage?) -> Void) -> [UIImage?] {
        
        fetchDataAtStorageRef(source: "UserArt/"+art.source!) { data, error in
            
            if let error = error {
                print(error)
            }
                
            guard let width = art.width,
                  let height = art.height else {
                return
            }
            
            let artImage = UIImage(data: data!)
            let resizedArtImage = UIImage.resizeImage(image: artImage!, targetSize: CGSize(width: Int(width)!, height: Int(height)!))
            
            completionHandler(resizedArtImage)
            
        }
        
        return [UIImage?]()
        
    }
    
    func addArtToCategory(category: Category, art: SavedArt) -> Bool {
        guard let categoryID = category.id else { return false }
        let categoryRef = firestore.collection("Categories").document(categoryID)
        categoryRef.updateData(["artworks" : FieldValue.arrayUnion([[
            "id": art.id,
            "name": art.name,
            "source": art.source,
            "width": art.width,
            "height": art.height,
            "pixelSize": art.pixelSize
        ]])])
        return true
    }
    
    func removeArtFromCategory(category: Category, art: SavedArt) -> Bool {
        guard let categoryID = category.id else { return false }
        let categoryRef = firestore.collection("Categories").document(categoryID) // Assumes document ID is == to category ID.
        categoryRef.updateData(["artworks": FieldValue.arrayRemove([[
            "id": art.id,
            "name": art.name,
            "source": art.source,
            "width": art.width,
            "height": art.height,
            "pixelSize": art.pixelSize
        ]])])
        return true
    }
    
    func fetchAllArtImagesFromCategory(category: Category, completionHandler: @escaping ([UIImage?]) -> Void) -> [UIImage?] {
        
        var categoryArtImages = [UIImage?](repeating: nil, count: category.artworks.count)
        
        var noAttempts = 0
        
        for (index, artwork) in category.artworks.enumerated() {
            
            guard let source = artwork.source else {
                noAttempts += 1
                continue
            }
            
            fetchDataAtStorageRef(source: "CategoryArt/"+source) { data, error in
                
                if let error = error {
                    noAttempts += 1
                    print(error)
                    return
                }
                
                guard let artworkUIImage = UIImage(data: data!) else {
                    noAttempts += 1
                    print("The data from the reference endpoint could not be decoded into a UIImage.")
                    return
                }
                
                categoryArtImages[index] = artworkUIImage
                noAttempts += 1
                
                if noAttempts == category.artworks.count {
                    completionHandler(categoryArtImages)
                }
                
            }
            
        }
        
        return categoryArtImages
        
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
    
    func fetchAllArtImagesFromUser(user: User, completionHandler: @escaping ([UIImage?]) -> Void) -> [UIImage?] {
        
        var userArtImages = [UIImage?](repeating: nil, count: user.artworks.count)
        
        var noAttempts = 0
        
        for (index, artwork) in user.artworks.enumerated() {
            
            guard let source = artwork.source else {
                noAttempts += 1
                continue
            }
            
            fetchDataAtStorageRef(source: "UserArt/"+source) { data, error in
                
                if let error = error {
                    noAttempts += 1
                    print(error)
                    return
                }
                
                guard let artworkUIImage = UIImage(data: data!) else {
                    noAttempts += 1
                    print("The data from the reference endpoint could not be decoded into a UIImage.")
                    return
                }
                
                userArtImages[index] = artworkUIImage
                noAttempts += 1
                
                if noAttempts == user.artworks.count {
                    completionHandler(userArtImages)
                }
                
            }
            
        }
        
        return userArtImages
        
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
    
    func fetchDataAtStorageRef(source: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        /*
        :param source: the path from root of Firebase Storage to file location -- i.e. "images/stars.jpg".
        */
        let targetRef = storage.reference(withPath: source)
        targetRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            completionHandler(data, error)
        }
    }
    
    func fetchDataAsUIImageAtStorageRef() {}
    
    func putDataAtStorageRef(source: String, data: Data) {
        let targetRef = storage.reference(withPath: source)
        let _ = targetRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
            }
        }
    }

}


