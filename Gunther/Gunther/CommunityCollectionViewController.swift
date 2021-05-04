//
//  CommunityCollectionViewController.swift
//  Gunther
//
//  Created by Joshua Ong on 4/5/21.
//

import UIKit

class CommunityCollectionViewController: UICollectionViewController, DatabaseListener {
    
    var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.user
    
    let COMMUNITY_SECTION = 0
    let COMMUNITY_CELL = "CommunityCell"
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Get reference to database contoller
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return
        }
        databaseController = appDelegate.databaseController
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: COMMUNITY_CELL)

    }
    
    // MARK: - Implement DatabaseListener protocol
    
    func onCategoriesChange(change: DatabaseChange, categories: [Category]) {
        self.categories = categories
    }
    
    func onUserChange(change: DatabaseChange, user: User) {}
    
    // MARK: - Implement setup/destruction on view appear and disappear
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        databaseController?.removeListener(listener: self)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let communityCell = collectionView.dequeueReusableCell(withReuseIdentifier: COMMUNITY_CELL, for: indexPath)
        
        let category = categories[indexPath.row]
        //communityCell.name = category.name
        // Also have a cover image.
        
        return communityCell
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}