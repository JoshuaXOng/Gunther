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

/*
 * An implementation of RemoteDatabaseProtocol, based off of the
 * Firebase services.
 */
class FirebaseController: NSObject, RemoteDatabaseProtocol {
    
    var listeners = MulticastDelegate<DatabaseListener>()
    
    var categories = [Category]()
    var user = User()
    
    // References to Firebase services.
    var authController: Auth
    var firestore: Firestore
    var storage: Storage
    
    // References to Firebase Firestore entities.
    var categoriesRef: CollectionReference?
    var userRef: DocumentReference?
    
    // Define variables for Firebase Storage directory structure.
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
    
    // Cleanup is not needed given the auto-saving nature of Firebase.
    func cleanup() {}
    
    /*
     * Adds a listener to this database database controller.
     * Additionally, the listener will automatically get triggered initially.
     */
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
    
    /* Removes a listener from this database controller. */
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    /* Adds an art to a category in the database.
     *
     * Whilst supplying Category and SavedArt classes, in the Firestore database,
     * the category is only given a reference to the art (which is to be located in Storage).
     * Additionally, this only records the change in Firestore -- it DOES NOT upload the corresponding
     * art data to Storage.
     *
     * Only works on the precondition that the category's id matches one found in Firestore.
     */
    func addArtToCategory(category: Category, art: SavedArt) -> Bool {
        
        guard let categoryID = category.id else {
            print("Adding art to category, but cate.'s id is nil.")
            return false
        }
        let documentID = categoryID
        let categoryRef = firestore.collection("Categories").document(documentID)
        
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
    
    /* Removes an art from a category in the database.
     * Only works on the precondition that the category's id matches one found in Firestore.
     */
    func removeArtFromCategory(category: Category, art: SavedArt) -> Bool {
        
        guard let categoryID = category.id else {
            print("Removing art from category, but cate.'s id is nil.")
            return false
        }
        let documentID = categoryID
        let categoryRef = firestore.collection("Categories").document(documentID)
        
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
    
    /* Adds an art to a user in the database. */
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
    
    /* Removes an art from the user in the database. */
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
    
    /* Copies an art from a user to a category.
     * The art's data is uploaded again as a duplicate -- and, moreover, given a seperate id
     * to reference.
     */
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
    
    /* Copies an art from a category to a user.
     * The art's data is uploaded again as a duplicate -- and, moreover, given a
     * seperate id to reference.
     */
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
    
    /* Fetches the underlying image data of an art.
     * The completion handler is provided the image data as a UIImage.
     */
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
    
    /* Fetches the underlying image data of artworks from a category.
     * The completion handler is only triggered when all artworks have been fetched.
     * The completion handler is passed the UIImages of all the artworks.
     */
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
    
    /*
     * Fetches the images that the categories themselves display.
     * The completion handler is only triggered when all images have been fetched.
     * The completion handler is passed the images as UIImages.
     */
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
    
    /* Fetches the underlying artwork data from the artworks of the user.
     * The completion handler is only called when all artworks have been fetched.
     * The completion handler is provided the data as UIImages.
     */
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
    
    /* Sets up the database controller to 'listen' to changes in the Firestore database, for the categories. */
    func setupCategoriesListener() {
        categoriesRef?.addSnapshotListener() { (querySnapshot, error) in
                    
            guard let querySnapshot = querySnapshot else {
                print("Yikes! Error fetching categories: \(String(describing: error))")
                return
            }
                    
            self.parseCategoriesSnapshot(snapshot: querySnapshot)
                
        }
    }
    
    /* Sets up the database controller to 'listen' to changes in the Firestore databse, for the user. */
    func setupUserListener() {
        userRef?.addSnapshotListener() { (documentSnapshot, error) in
            
            guard let documentSnapshot = documentSnapshot else {
                print("Yikes. Failed to fetch document with error: \(String(describing: error))")
                return
            }
            
            self.parseUserSnapshot(snapshot: documentSnapshot)
        
        }
    }
    
    /* Executes logic based on a snapshot of the Firestore database, for the categories.
     * Updates local variable representation of categories to reflect Firestore databse.
     * Triggers all and category listeners of this database controller.
     */
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
    
    /* Executes logic based on a snapshot of the Firestore databse, for the user.
     * Updates local variable representation of the user to reflect Firestore database.
     * Triggres all and user listeners of this databse controller.
     */
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
    
    /* Fetches data from the Storage reference.
     * The data is received as a Swift Data object which is then passed to the completion handler.
     */
    func fetchDataAtStorageRef(resource: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        let targetRef = storage.reference(withPath: resource)
        targetRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            completionHandler(data, error)
        }
    }
    
    /* Stores data at the Storage reference. */
    func putDataAtStorageRef(resource: String, data: Data, completionHandler: @escaping (Error?) -> Void) {
        let targetRef = storage.reference(withPath: resource)
        let _ = targetRef.putData(data, metadata: nil) { (metadata, error) in
            completionHandler(error)
        }
    }

}


