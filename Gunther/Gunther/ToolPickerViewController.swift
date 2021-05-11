//
//  ToolPickerViewController.swift
//  Gunther
//
//  Created by user184453 on 5/10/21.
//

import UIKit

class ToolPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var typeCollectionView: UICollectionView?
    var sizeCollectionView: UICollectionView?
    
    let TYPE_VC_TYPE_CELL = "TypeCell"
    let SIZE_VC_SIZE_CELL = "SizeCell"
    
    var selectedToolTypeIndex = 0
    var selectedToolSizeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
        
        setupTypeCVC()
        setupSizeCVC()
        
    }
    
    // MARK: - Encapsulation for setting up
    
    private func setupVC() {
        
        view.backgroundColor = UIColor.white
        
        let title = UILabel(frame: CGRect(x: 50, y: 40, width: 60, height: 20))
        title.text = "Tools"
        view.addSubview(title)
        
    }
    
    private func setupTypeCVC() {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsetsTypeVC
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.scrollDirection = .horizontal
        typeCollectionView = UICollectionView(frame: CGRect(x: (view.frame.size.width-300)/2, y: 100, width: 300, height: 150), collectionViewLayout: layout)
        
        typeCollectionView?.backgroundColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        
        typeCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: TYPE_VC_TYPE_CELL)
        
        typeCollectionView?.delegate = self
        typeCollectionView?.dataSource = self
        view.addSubview(typeCollectionView!)
        
    }
    
    private func setupSizeCVC() {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsetsSizeVC
        layout.itemSize = CGSize(width: 60, height: 60)
        sizeCollectionView = UICollectionView(frame: CGRect(x: (view.frame.size.width-300)/2, y: 300, width: 300, height: 400), collectionViewLayout: layout)
        
        sizeCollectionView?.backgroundColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        
        sizeCollectionView?.register(ToolSizeCollectionViewCell.self, forCellWithReuseIdentifier: SIZE_VC_SIZE_CELL)
        
        sizeCollectionView?.delegate = self
        sizeCollectionView?.dataSource = self
        view.addSubview(sizeCollectionView!)

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
            let typeCell = collectionView.dequeueReusableCell(withReuseIdentifier: TYPE_VC_TYPE_CELL, for: indexPath)
            if indexPath.row == selectedToolTypeIndex {
                applySelectedVisualsToCell(cell: typeCell)
            }
            else {
                applyDeselectVisualsToCell(cell: typeCell)
            }
            typeCell.backgroundColor = UIColor.white
            return typeCell
        }
        
        let sizeCell = collectionView.dequeueReusableCell(withReuseIdentifier: SIZE_VC_SIZE_CELL, for: indexPath) as? ToolSizeCollectionViewCell
        if indexPath.row == selectedToolSizeIndex {
            applySelectedVisualsToCell(cell: sizeCell)
        }
        else {
            applyDeselectVisualsToCell(cell: sizeCell)
        }
        sizeCell!.backgroundColor = UIColor.white
        return sizeCell!
        
    }
    
    // MARK: - Implement UICollectionViewDelegateFlowLayout
    
    private let sectionInsetsTypeVC = UIEdgeInsets(
        top: 5.0,
        left: 10.0,
        bottom: 5.0,
        right: 10.0)
    private let sectionInsetsSizeVC = UIEdgeInsets(
        top: 10.0,
        left: 10.0,
        bottom: 10.0,
        right: 10.0)
    
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
