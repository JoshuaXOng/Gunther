//
//  ToolPickerViewController.swift
//  Gunther
//
//  Created by user184453 on 5/10/21.
//

import UIKit

class ToolPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    //var typeCollectionView = UICollectionView(frame: CGRect(x: 10, y: 40, width: 500, height: 150))
    
    let TYPE_CELL = "TypeCell"
    let SIZE_CELL = "SizeCell"
    
    var selectedToolTypeIndex = 0
    var selectedToolSizeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        typeCollectionView.delegate = self
        sizeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        sizeCollectionView.dataSource = self
        
        /*
        let typeIndexPath = IndexPath(row: selectedToolTypeIndex, section: 0)
        let typeCell = typeCollectionView.cellForItem(at: typeIndexPath)
        applySelectedVisualsToCell(cell: typeCell)
        let sizeIndexPath = IndexPath(row: selectedToolSizeIndex+7, section: 0)
        let sizeCell = sizeCollectionView.cellForItem(at: sizeIndexPath)
        applySelectedVisualsToCell(cell: sizeCell)*/
        
    }
    
    // MARK: - Utils for changing visuals of cells
    
    func applySelectedVisualsToCell(cell: UICollectionViewCell?) {
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.blue.cgColor
    }
    
    func applyDeselectVisualsToCell(cell: UICollectionViewCell?) {
        cell?.layer.borderWidth = 0
    }
    
    // MARK: - Implement UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == typeCollectionView {
            let oldIndexPath = IndexPath(row: selectedToolTypeIndex, section: 0)
            let oldCell = collectionView.cellForItem(at: oldIndexPath)
            applyDeselectVisualsToCell(cell: oldCell)
            selectedToolTypeIndex = indexPath.row
        }
        
        else {
            let oldIndexPath = IndexPath(row: selectedToolSizeIndex, section: 0)
            let oldCell = collectionView.cellForItem(at: oldIndexPath)
            applyDeselectVisualsToCell(cell: oldCell)
            selectedToolSizeIndex = indexPath.row
        }
        
        let cell = collectionView.cellForItem(at: indexPath)
        applySelectedVisualsToCell(cell: cell)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath)
        //applyDeselectVisualsToCell(cell: cell)
        /*
        if collectionView == typeCollectionView {
            selectedToolTypeIndex = indexPath.row
        }
        else {
            selectedToolSizeIndex = indexPath.row
        }*/
    }
    
    // MARK: - Implement UICollectionViewDataSource
    
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
            if indexPath.row == selectedToolTypeIndex {
                applySelectedVisualsToCell(cell: typeCell)
            }
            else {
                applyDeselectVisualsToCell(cell: typeCell)
            }
            return typeCell
        }
        
        let sizeCell = collectionView.dequeueReusableCell(withReuseIdentifier: SIZE_CELL, for: indexPath)
        if indexPath.row == selectedToolSizeIndex {
            applySelectedVisualsToCell(cell: sizeCell)
        }
        else {
            applyDeselectVisualsToCell(cell: sizeCell)
        }
        return sizeCell
        
    }
    
    // MARK: - Implement UICollectionViewDelegateFlowLayout
    
    private let sectionInsetsTypeVC = UIEdgeInsets(
        top: 5.0,
        left: 5.0,
        bottom: 5.0,
        right: 5.0)
    private let sectionInsetsSizeVC = UIEdgeInsets(
        top: 5.0,
        left: 5.0,
        bottom: 5.0,
        right: 5.0)
    
    private let itemsPerRowTypeVC: CGFloat = 2
    private let itemsPerRowSizeVC: CGFloat = 1
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == typeCollectionView {
            let paddingSpace = sectionInsetsTypeVC.left * (itemsPerRowTypeVC + 1)
            let availableWidth = collectionView.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRowTypeVC
            return CGSize(width: widthPerItem, height: widthPerItem-50)
        }
        let paddingSpace = sectionInsetsSizeVC.left * (itemsPerRowSizeVC + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRowSizeVC
        return CGSize(width: widthPerItem, height: 60)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == typeCollectionView {
            return sectionInsetsTypeVC
        }
        return sectionInsetsSizeVC
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == typeCollectionView {
            return sectionInsetsTypeVC.bottom
        }
        return sectionInsetsSizeVC.bottom
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
