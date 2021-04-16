//
//  NewArtCollectionViewController.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import UIKit

class NewArtCollectionViewController: UICollectionViewController {

    let SECTION_COMPOSITION = 0
    let SECTION_PHOTO = 1
    let SECTION_BLANK = 2
    let CELL_COMPOSITION = "CompositionCell"
    let CELL_PHOTO = "PhotoCell"
    let CELL_BLANK = "BlankCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CELL_COMPOSITION)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CELL_PHOTO)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CELL_BLANK)

        // Do any additional setup after loading the view.
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
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == SECTION_COMPOSITION {
            let compositionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_COMPOSITION, for: indexPath)
            return compositionCell
        }
        else if indexPath.section == SECTION_PHOTO {
            let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_PHOTO, for: indexPath)
            return photoCell
        }
        let blankCell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_BLANK, for: indexPath)
        return blankCell
        
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
