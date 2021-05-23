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
        
        // Assign GenericArtCollectionViewController instance variables.
        if community != nil {
            art = community!.artworks
            artImages = [UIImage?](repeating: nil, count: art.count)
        }
        
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
        
        let remoteDatabaseController = databaseController as? RemoteDatabaseProtocol
        remoteDatabaseController?.fetchAllArtImagesFromCategory(category: community!) { [self] images in
            art = community!.artworks
            artImages = images
            collectionView.reloadData()
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
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let artwork = art[indexPath.row]
        actionSheet.title = artwork.name
        
        actionSheet.addAction(UIAlertAction(title: "Download", style: .default) { [self] _ in
            guard let user = (databaseController as? FirebaseController)?.user else {
                return
            }
            databaseController?.copyArtFromCategoryToUser(category: community!, user: user, artwork: artwork)
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




    

