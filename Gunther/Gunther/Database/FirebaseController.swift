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

class FirebaseController: NSObject, RemoteDatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    var categories = [Category]()
    var user = User()
    
    // References to Firebase services and entities.
    var authController: Auth
    var firestore: Firestore
    var storage: Storage
    var categoriesRef: CollectionReference?
    var userRef: DocumentReference?
    
    let CATEGORY_DIR = "CategoryArt/"
    let USER_DIR = "UserArt/"
    
    override init() {
        
        FirebaseApp.configure()
        authController = Auth.auth()
        firestore = Firestore.firestore()
        storage = Storage.storage()
        
        super.init()
        
        authController.signInAnonymously() { [self] (authResult, error) in
            
            guard authResult != nil else {
                fatalError("Firebase Auth failed with Error: \(String(describing: error))")
            }
            
            userRef = firestore.collection("Users").document("3TvMj0AkUw6BSRuFEW18") // Test user.
            categoriesRef = firestore.collection("Categories")
            setupUserListener()
            setupCategoriesListener()
        
        }
        
    }
    
    // MARK: - (Remote)DatabaseProtocol
    
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
            print("Adding art to category, but cate.'s id is nil.")
            return false
        }
        let documentID = categoryID
        let categoryRef = firestore.collection("Categories").document(documentID) // Assumes document ID is == to category ID.
        
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
        
        guard let categoryID = category.id else {
            print("Removing art from category, but cate.'s id is nil.")
            return false
        }
        let documentID = categoryID
        let categoryRef = firestore.collection("Categories").document(documentID) // Assumes document ID is == to category ID.
        
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
    
    func copyArtFromUserToCategory(user: User, category: Category, artwork: SavedArt) {
        
        let artworkCopy = artwork.copy_()
        guard let source = artwork.source,
              let newSource = artworkCopy.source else {
            return
        }
        let originalResource = USER_DIR+source
        let newResource = CATEGORY_DIR+newSource
        
        fetchDataAtStorageRef(resource: originalResource) { [self] data, error in
            putDataAtStorageRef(resource: newResource, data: data!) { error in
                _ = addArtToCategory(category: category, art: artworkCopy)
            }
        }
        
    }
    
    func copyArtFromCategoryToUser(category: Category, user: User, artwork: SavedArt) {
                
        let artworkCopy = artwork.copy_()
        guard let source = artwork.source,
              let newSource = artworkCopy.source else {
            return
        }
        let originalResource = CATEGORY_DIR+source
        let newResource = USER_DIR+newSource
        
        fetchDataAtStorageRef(resource: originalResource) { [self] data, error in
            putDataAtStorageRef(resource: newResource, data: data!) { error in
                _ = addArtToUser(user: user, art: artworkCopy)
            }
        }
        
    }
    
    // MARK: - RemoteDatabaseProtocol
    
    func fetchArtImageFromArt(art: SavedArt, completionHandler: @escaping (UIImage?) -> Void) throws {
        
        guard let source = art.source else {
            throw DatabaseExceptions.invalidResource("Fetching art image, but source is nil.")
        }
        let resource = USER_DIR+source
        
        fetchDataAtStorageRef(resource: resource) { data, error in
            
            if let error = error {
                print(error)
                return
            }
                
            guard let width = art.width, let height = art.height, let artData = data, let artImage = UIImage(data: artData) else {
                print("Fetching art, but width, height, data or conversion to UIImage is nil.")
                return
            }
            // Resizing image is needed: when uploading to Firebase, the images change dimensions.
            // Could be that addition metadata is needed when uploading?
            let resizedArtImage = UIImage.resizeImage(image: artImage, targetSize: CGSize(width: Int(width)!, height: Int(height)!))
            
            completionHandler(resizedArtImage)
            
        }
        
    }
    
    func fetchAllArtImagesFromCategory(category: Category, completionHandler: @escaping ([UIImage?]) -> Void) {
        
        var categoryArtImages = [UIImage?](repeating: nil, count: category.artworks.count)
        
        var noAttempts = 0
        for (index, artwork) in category.artworks.enumerated() {
            
            guard let source = artwork.source else {
                noAttempts += 1
                continue
            }
                
            let resource = CATEGORY_DIR+source
            fetchDataAtStorageRef(resource: resource) { data, error in
                
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
                
                // The completion handler is called upon having tried to fetch images the same number of times as there are images.
                // As such, the handler is called when no more fetches - no more async updates - will occur.
                if noAttempts == category.artworks.count {
                    completionHandler(categoryArtImages)
                }
                
            }
            
        }
        
    }
    
    func fetchCategoriesThumbnails(completionHandler: @escaping ([UIImage?]) -> Void) {
        
        var categoriesImages = [UIImage?](repeating: nil, count: categories.count)
        
        var noAttempts = 0
        for (index, category) in categories.enumerated() {
            
            guard let source = category.source else {
                noAttempts += 1
                continue
            }
            
            self.fetchDataAtStorageRef(resource: source) { data, error in
                
                if let error = error {
                    noAttempts += 1
                    print(error)
                    return
                }
                
                guard let thumbnailData = data, let categoryUIImage = UIImage(data: thumbnailData) else {
                    noAttempts += 1
                    print("The data from the reference endpoint could not be decoded into a UIImage.")
                    return
                }
                
                categoriesImages[index] = categoryUIImage
                noAttempts += 1
                
                if noAttempts == self.categories.count {
                    completionHandler(categoriesImages)
                }
                
            }
            
        }
        
    }
    
    func fetchAllArtImagesFromUser(user: User, completionHandler: @escaping ([UIImage?]) -> Void) {
        
        var userArtImages = [UIImage?](repeating: nil, count: user.artworks.count)
        
        var noAttempts = 0
        for (index, artwork) in user.artworks.enumerated() {
            
            guard let source = artwork.source else {
                noAttempts += 1
                continue
            }
            
            let resource = USER_DIR+source
            fetchDataAtStorageRef(resource: resource) { data, error in
                
                if let error = error {
                    noAttempts += 1
                    print(error)
                    return
                }
                
                guard let artData = data, let artworkUIImage = UIImage(data: artData) else {
                    noAttempts += 1
                    print("The data from the reference endpoint could not be decoded into a UIImage.")
                    return
                }
                
                userArtImages[index] = artworkUIImage
                noAttempts += 1
                
                // The completion handler is called upon having tried to fetch images the same number of times as there are images.
                // As such, the handler is called when no more fetches - no more async updates - will occur.
                if noAttempts == user.artworks.count {
                    completionHandler(userArtImages)
                }
                
            }
            
        }
        
    }
    
    // MARK: - Firebase listeners
     
    func setupCategoriesListener() {
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
            
            // Update locally stored reference of categories.
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
    
    // MARK: - Firebase storage
    
    func fetchDataAtStorageRef(resource: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        let targetRef = storage.reference(withPath: resource)
        targetRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            completionHandler(data, error)
        }
    }
    
    func putDataAtStorageRef(resource: String, data: Data, completionHandler: @escaping (Error?) -> Void) {
        let targetRef = storage.reference(withPath: resource)
        let _ = targetRef.putData(data, metadata: nil) { (metadata, error) in
            completionHandler(error)
        }
    }

}


