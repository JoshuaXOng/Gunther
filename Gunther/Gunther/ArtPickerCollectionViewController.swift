//
//  ArtPickerCollectionViewController.swift
//  Gunther
//
//  Created by user184453 on 5/15/21.
//

import UIKit

class ArtPickerCollectionViewController: GenericArtCollectionViewController, DatabaseListener {

    var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.user
    
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get a reference to the applications database controller (cast it into Firebase controller)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        databaseController = appDelegate.databaseController
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: - Implement DatabaseListner

    func onCategoriesChange(change: DatabaseChange, categories: [Category]) {}
    
    func onUserChange(change: DatabaseChange, user: User) {
        let firebaseController = databaseController as? FirebaseController
        _ = firebaseController?.fetchAllArtImagesFromUser(user: user) { images in
            self.art = user.artworks
            self.artImages = images
            self.collectionView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let firebaseController = databaseController as? FirebaseController
        
        let artCopy = art[indexPath.row].copy_()
        
        firebaseController?.fetchDataAtStorageRef(source: "UserArt/"+art[indexPath.row].source!) { data, error in
            
            firebaseController?.putDataAtStorageRef(source: "CategoryArt/"+artCopy.source!, data: data!) {
            
                _ = firebaseController?.addArtToCategory(category: self.category!, art: artCopy)
                
            }
            
        }
            
        dismiss(animated: true, completion: nil)
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}