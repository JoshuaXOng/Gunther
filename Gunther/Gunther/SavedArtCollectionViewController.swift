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
        
        actionSheet.addAction(UIAlertAction(title: "Rename", style: .default) { _ in
            self.promptRename(user: user, art: artSingular)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Copy", style: .default) { _ in
            self.copyAction(user: user, artSingular: artSingular)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default) { _ in
            self.performSegue(withIdentifier: "SavedArtToArtSegue", sender: nil)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
 
        self.present(actionSheet, animated: true, completion: nil)
        
        return true
        
    }
    
    // MARK: - Utils for action sheet.
    
    private func promptRename(user: User, art: SavedArt) {
        
        let prompt = UIAlertController(title: "Rename Art", message: "Enter a new name...", preferredStyle: .alert)
        
        prompt.addTextField() { textField in
            textField.placeholder = "Name"
        }
        
        prompt.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        prompt.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            
            let input = prompt.textFields![0].text!
            if input.trimmingCharacters(in: .whitespaces).isEmpty {
                self.displayMessage(title: "Invalid name", message: "Please enter a valid name.")
                return
            }
            
            let newName = input
            self.renameAction(user: user, artSingular: art, newName: newName)
            
        }))
        
        present(prompt, animated: true)
        
    }
    
    private func renameAction(user: User, artSingular: SavedArt, newName: String) {
        _ = databaseController?.removeArtFromUser(user: user, art: artSingular)
        artSingular.name = newName
        _ = databaseController?.addArtToUser(user: user, art: artSingular)
    }
    
    private func copyAction(user: User, artSingular: SavedArt) {
        
        let artSingularCopy = artSingular.copy_()
        
        let firebaseController = self.databaseController as? FirebaseController
        
        firebaseController?.fetchDataAtStorageRef(source: "UserArt/"+artSingular.source!) { data, error in
            
            firebaseController?.putDataAtStorageRef(source: "UserArt/"+artSingularCopy.source!, data: data!) {
            
                _ = self.databaseController?.addArtToUser(user: user, art: artSingularCopy)
                
            }
            
        }
        
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
