//
//  SpecCommunityCollectionViewController.swift
//  Gunther
//
//  Created by user184453 on 5/13/21.
//

import UIKit

class SpecCommunityCollectionViewController: GenericArtCollectionViewController, DatabaseListener {
    
    var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.categories
    
    var community: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get a reference to the applications database controller (cast it into Firebase controller)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        databaseController = appDelegate.databaseController
        
        art = community!.artworks
        artImages = [UIImage?](repeating: nil, count: art.count)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: - DatabaseListener

    func onCategoriesChange(change: DatabaseChange, categories: [Category]) {
        
        let updatedCommunity = categories.filter { $0.id == community?.id }
        community = updatedCommunity.first
        
        let firebaseController = databaseController as? FirebaseController
        _ = firebaseController?.fetchAllArtImagesFromCategory(category: community!) { images in
            self.art = self.community!.artworks
            self.artImages = images
            self.collectionView.reloadData()
        }
        
    }
    
    func onUserChange(change: DatabaseChange, user: User) {}

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let firebaseController = databaseController as? FirebaseController
        guard let user = firebaseController?.user else { return true }
        let art = self.art[indexPath.row]
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.title = art.name
        
        actionSheet.addAction(UIAlertAction(title: "Download", style: .default) { _ in
            
            let artCopy = art.copy_()
            
            firebaseController?.fetchDataAtStorageRef(source: "CategoryArt/"+art.source!) { data, error in
                
                firebaseController?.putDataAtStorageRef(source: "UserArt/"+artCopy.source!, data: data!) {
                    
                    _ = firebaseController?.addArtToUser(user: user, art: artCopy)
                
                }
                
            }
            
        })

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
 
        self.present(actionSheet, animated: true, completion: nil)
        
        return true
        
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SpecComToSavedArtPrevSegue" {
            let destination = segue.destination as? ArtPickerCollectionViewController
            destination?.category = community
        }
    }

}




    

