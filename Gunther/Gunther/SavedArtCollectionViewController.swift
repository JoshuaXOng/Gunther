//
//  SavedArtCollectionViewController.swift
//  Gunther
//
//  Created by user184453 on 4/25/21.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class SavedArtCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let SAVED_ART_SECTION = 0
    let SAVED_ART_CELL = "SavedArtCell"
    var savedArt = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: SAVED_ART_CELL)
        
        // Get a reference to the applications database controller
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let databaseController = appDelegate.databaseController else { return }
        guard let firebaseController = databaseController as? FirebaseController else {
            return
        }
        
        let rootRef = firebaseController.storage.reference()
        
        let gPPNGRef = firebaseController.storage.reference(withPath: "GuntherPixi.png")
        let testRef = rootRef.child("test.png")
        
        gPPNGRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                //let iv = UIImageView(image: image)
                self.savedArt.append(image!)
                self.savedArt.append(image!)
                //self.view.addSubview(iv)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadSections([self.SAVED_ART_SECTION])
                }
            }
        }
        
        testRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                //let iv = UIImageView(image: image)
                self.savedArt.append(image!)
                self.savedArt.append(image!)
                //self.view.addSubview(iv)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadSections([self.SAVED_ART_SECTION])
                }
            }
        }
        
        // This controller needs database listeners (along with community section -- average pooling to scale art)
        
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
        return savedArt.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let savedArtCell = collectionView.dequeueReusableCell(withReuseIdentifier: SAVED_ART_CELL, for: indexPath)
        
        let iv = UIImageView(image: savedArt[indexPath.row])
        // Need to remove all subviews
        savedArtCell.contentView.addSubview(iv)
        //savedArtCell.contentView.backgroundColor = UIColor.black
        iv.frame = savedArtCell.contentView.bounds
    
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
