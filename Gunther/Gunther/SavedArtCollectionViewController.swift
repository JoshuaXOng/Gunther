//
//  SavedArtCollectionViewController.swift
//  Gunther
//
//  Created by user184453 on 4/25/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class SavedArtCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DatabaseListener {
    
    var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.user
    
    let SAVED_ART_SECTION = 0
    let SAVED_ART_CELL = "SavedArtCell"
    var savedArt = [SavedArt]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: SAVED_ART_CELL)
        
        // Get a reference to the applications database controller
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        databaseController = appDelegate.databaseController
        
    }
    
    // MARK: - Implement DatabaseListner

    func onCategoriesChange(change: DatabaseChange, categories: [Category]) {}
    
    func onUserChange(change: DatabaseChange, user: User) {
        savedArt = user.artworks
        collectionView.reloadSections([SAVED_ART_SECTION])
    }
    
    // MARK: - View (dis)appearance setup/deconstructing
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedArt.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let savedArtCell = collectionView.dequeueReusableCell(withReuseIdentifier: SAVED_ART_CELL, for: indexPath)
        
        let savedArtSingular = savedArt[indexPath.row]
        guard let source = savedArtSingular.source,
              let firebaseController = databaseController as? FirebaseController else {
            return savedArtCell
        }
        // Makes sure to encode the URL.
        let reference = firebaseController.storage.reference(withPath: source)
        
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            
            if let error = error {
                print(error)
            }
            
            else {
                
                guard let imageOfSavedArt = UIImage(data: data!) else { return }
                let imageViewOfSavedArt = UIImageView(image: imageOfSavedArt)
                
                // You need to identify which piece has changed and do the below just for that one.
                DispatchQueue.main.async {
                    savedArtCell.contentView.subviews.forEach({ $0.removeFromSuperview() })
                    savedArtCell.contentView.addSubview(imageViewOfSavedArt)
                    imageViewOfSavedArt.frame = savedArtCell.contentView.bounds
                    //self.collectionView.reloadSections([self.SAVED_ART_SECTION])
                }
                
            }
            
        }
    
        return savedArtCell
        
    }
    
    // MARK: - Implement UICollectionViewDelegateFlowLayout
    
    /* CODE FROM:
     https://www.raywenderlich.com/18895088-uicollectionview-tutorial-getting-started/
    */
    
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 20.0,
      bottom: 50.0,
      right: 20.0)
    
    private let itemsPerRow: CGFloat = 2
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout:UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard let firebaseController = databaseController as? FirebaseController else {
            return false
        }
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            let user = firebaseController.user
            let art = self.savedArt[indexPath.row]
            let _ = firebaseController.removeArtFromUser(user: user, art: art)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Share", style: .default))
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default) { _ in
            self.performSegue(withIdentifier: "SavedArtToArtSegue", sender: nil)
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
 
        self.present(actionSheet, animated: true, completion: nil)
        
        return true
        
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SavedArtToArtSegue" {
            let noOfSelectedArt = collectionView.indexPathsForSelectedItems![0].row
            let selectedArt = savedArt[noOfSelectedArt]
            let destination = segue.destination as? ArtViewController
            destination?.savedArt = selectedArt
        }
    }

}
