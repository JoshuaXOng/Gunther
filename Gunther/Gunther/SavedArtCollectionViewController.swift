//
//  SavedArtCollectionViewController.swift
//  Gunther
//
//  Created by user184453 on 4/25/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class SavedArtCollectionViewController: GenericArtCollectionViewController, DatabaseListener {
    
    var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.user
    
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
    
    // MARK: UICollectionViewDelegate
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {

        guard let firebaseController = databaseController as? FirebaseController else {
            return false
        }
        let user = firebaseController.user
        let artSingular = self.art[indexPath.row]
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.title = artSingular.name
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            let _ = firebaseController.removeArtFromUser(user: user, art: artSingular)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Share", style: .default) { _ in
            self.performSegue(withIdentifier: "SavedArtToShareArtSegue", sender: nil)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default) { _ in
            self.performSegue(withIdentifier: "SavedArtToArtSegue", sender: nil)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
 
        self.present(actionSheet, animated: true, completion: nil)
        
        return true
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SavedArtToArtSegue" {
            let noOfSelectedArt = collectionView.indexPathsForSelectedItems![0].row
            let selectedArt = art[noOfSelectedArt]
            let destination = segue.destination as? ArtViewController
            destination?.savedArt = selectedArt
        }
    }

}
