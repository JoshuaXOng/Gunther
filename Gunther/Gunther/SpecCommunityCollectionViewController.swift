//
//  SpecCommunityCollectionViewController.swift
//  Gunther
//
//  Created by user184453 on 5/13/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class SpecCommunityCollectionViewController: UICollectionViewController {
    
    var databaseController: DatabaseProtocol?
    var firebaseController: FirebaseController?
    var listenerType = ListenerType.categories
    
    let ART_SECTION = 0
    let ART_CELL = "ArtCell"
    var community: Category?
    var art = [SavedArt]()
    var artImages = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(SavedArtCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Get a reference to the applications database controller (cast it into Firebase controller)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        databaseController = appDelegate.databaseController
        firebaseController = databaseController as? FirebaseController
        
        art = community!.artworks
        fetchImages()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return art.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        let artCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SavedArtCollectionViewCell
    
        if artImages.count == art.count {
            guard let image = artImages[indexPath.row] else { return artCell! }
            artCell!.imageView?.image = image
            artCell!.label?.text = art[indexPath.row].name
        }
        
        return artCell!
    
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

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

// MARK: - Database functions

extension SpecCommunityCollectionViewController {
    
    private func fetchImages() {
        
        artImages = [UIImage?](repeating: nil, count: art.count)
        var counter = 0
        
        for (index, artSingular) in art.enumerated() {
            
            guard let source = artSingular.source else { return }
            
            firebaseController?.fetchDataAtStorageRef(source: source) { data in
                
                counter += 1
                
                guard let artUIImage = UIImage(data: data) else { return }
                
                self.artImages.remove(at: index)
                self.artImages.insert(artUIImage, at: index)

                // Can't append must replace -- we do not know the order in which responses will be delivered.
                if counter == self.art.count {
                    self.onFetchImagesCompletion()
                }
                
            }
            
        }
        
    }
    
    private func onFetchImagesCompletion() {
        self.collectionView.reloadData()
    }
    
}
