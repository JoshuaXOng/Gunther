//
//  ToolPickerViewController.swift
//  Gunther
//
//  Created by user184453 on 5/10/21.
//

import UIKit

class ToolPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    let TYPE_CELL = "TypeCell"
    let SIZE_CELL = "SizeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typeCollectionView.delegate = self
        sizeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        sizeCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == typeCollectionView {
            return 2
        }
        else {
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == typeCollectionView {
            let typeCell = collectionView.dequeueReusableCell(withReuseIdentifier: TYPE_CELL, for: indexPath)
            return typeCell
        }
        let sizeCell = collectionView.dequeueReusableCell(withReuseIdentifier: SIZE_CELL, for: indexPath)
        return sizeCell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
