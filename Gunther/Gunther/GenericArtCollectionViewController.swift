//
//  GenericArtCollectionViewController.swift
//  Gunther
//
//  Created by user184453 on 5/15/21.
//

import UIKit

class GenericArtCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    let ART_SECTION = 0
    let ART_CELL = "SavedArtCell"
    var art = [SavedArt]()
    var artImages = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(ArtCollectionViewCell.self, forCellWithReuseIdentifier: ART_CELL)

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return art.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let artCell = collectionView.dequeueReusableCell(withReuseIdentifier: ART_CELL, for: indexPath) as! ArtCollectionViewCell
        
        if artImages.count == art.count {
            guard let image = artImages[indexPath.row] else { return artCell }
            artCell.imageView?.image = image
            artCell.label?.text = art[indexPath.row].name
        }
        
        return artCell
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.bottom
    }

}
