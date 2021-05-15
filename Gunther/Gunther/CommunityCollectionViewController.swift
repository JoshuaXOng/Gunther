//
//  CommunityCollectionViewController.swift
//  Gunther
//
//  Created by Joshua Ong on 4/5/21.
//

import UIKit

class CommunityCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, DatabaseListener {
    
    var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.categories
    
    let COMMUNITY_SECTION = 0
    let COMMUNITY_CELL = "CommunityCell"
    var categories = [Category]()
    var categoryImages = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Get reference to database contoller
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        databaseController = appDelegate.databaseController
        
        // Register cell classes
        self.collectionView!.register(CommunityCollectionViewCell.self, forCellWithReuseIdentifier: COMMUNITY_CELL)
        
        setupBackground()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    private func setupBackground() {
        
        // Initialize the background view.
        collectionView.backgroundView = UIView(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
        
        let bgView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        bgView.backgroundColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        bgView.layer.cornerRadius = 5
        collectionView.backgroundView?.addSubview(bgView)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.leftAnchor.constraint(equalTo: collectionView.backgroundView!.leftAnchor, constant: 10).isActive = true
        bgView.rightAnchor.constraint(equalTo: collectionView.backgroundView!.rightAnchor, constant: -10).isActive = true
        bgView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 40).isActive = true
        bgView.bottomAnchor.constraint(equalTo: collectionView.backgroundView!.bottomAnchor, constant: -10).isActive = true
        
    }
    
    // MARK: - DatabaseListner
    
    func onCategoriesChange(change: DatabaseChange, categories: [Category]) {
        self.categories = categories
        //categoryImages = ...len of self.categories...
        fetchCategoryImages()
    }
    
    func onUserChange(change: DatabaseChange, user: User) {}
    
    // MARK: - Database functions
        
    private func fetchCategoryImages() {
        
        let firebaseController = databaseController as? FirebaseController
        
        categoryImages = [UIImage?](repeating: nil, count: categories.count)
        
        var noAttempts = 0
        
        for (index, category) in categories.enumerated() {
            
            guard let source = category.source else {
                noAttempts += 1
                continue
            }
            
            firebaseController?.fetchDataAtStorageRef(source: source) { data, error in
                
                if let error = error {
                    noAttempts += 1
                    print(error)
                    return
                }
                
                guard let categoryUIImage = UIImage(data: data!) else {
                    noAttempts += 1
                    print("The data from the reference endpoint could not be decoded into a UIImage.")
                    return
                }
                
                self.categoryImages[index] = categoryUIImage
                noAttempts += 1
                
                if noAttempts == self.categories.count {
                    self.onFetchCategoryImagesCompletion()
                }
                
            }
            
        }
        
    }
        
    private func onFetchCategoryImagesCompletion() {
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 20.0,
      bottom: 30.0,
      right: 20.0)
    
    private let itemsPerRow: CGFloat = 3
    
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
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let communityCell = collectionView.dequeueReusableCell(withReuseIdentifier: COMMUNITY_CELL, for: indexPath) as? CommunityCollectionViewCell
        
        //if categories.count == categoryImages.count {
            let category = categories[indexPath.row]
            communityCell?.label?.text = category.name
            communityCell?.imageView?.image = categoryImages[indexPath.row]
        //}
        
        return communityCell!
    
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
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ComToSpecComSegue", sender: nil)
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
        
        if segue.identifier == "ComToSpecComSegue" {
            let destination = segue.destination as? SpecCommunityCollectionViewController
            let index = collectionView.indexPathsForSelectedItems?.first?.row
            destination?.community = categories[index!]
        }
        
    }
    
}

