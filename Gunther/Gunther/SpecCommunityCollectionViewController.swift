//
//  SpecCommunityCollectionViewController.swift
//  Gunther
//
//  Created by user184453 on 5/13/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class SpecCommunityCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DatabaseListener {
    
    var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.categories
    
    let ART_SECTION = 0
    let ART_CELL = "ArtCell"
    var community: Category?
    var art = [SavedArt]()
    var artImages = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(ArtCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Get a reference to the applications database controller (cast it into Firebase controller)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        databaseController = appDelegate.databaseController
        
        art = community!.artworks
        artImages = [UIImage?](repeating: nil, count: art.count)
        //fetchImages()
        
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
        _ = firebaseController?.fetchAllArtImagesFromCategory(category: self.community!) { images in
            self.art = self.community!.artworks
            self.onFetchArtImagesCompletion(images: images)
        }
        
    }
    
    func onUserChange(change: DatabaseChange, user: User) {}
    
    // MARK: - Database functions
    
    private func onFetchArtImagesCompletion(images: [UIImage?]) {
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.bottom
    }

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
 
        let artCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ArtCollectionViewCell
    
        //if artImages.count == art.count {
            guard let image = artImages[indexPath.row] else { return artCell! }
            artCell!.imageView?.image = image
            artCell!.label?.text = art[indexPath.row].name
        //}
        
        return artCell!
    
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
        
        let firebaseController = databaseController as? FirebaseController
        guard let user = firebaseController?.user else { return true }
        let art = self.art[indexPath.row]
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.title = art.name
        
        actionSheet.addAction(UIAlertAction(title: "Download", style: .default) { _ in
            _ = firebaseController?.addArtToUser(user: user, art: art)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}




    

