//
//  ToolPickerViewController.swift
//  Gunther
//
//  Created by user184453 on 5/10/21.
//

import UIKit

class ToolPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var toolPickerDelegate: ToolPickerDelegate?
    
    var typeCollectionView: UICollectionView?
    var sizeCollectionView: UICollectionView?
    
    let TYPE_VC_TYPE_CELL = "TypeCell"
    let SIZE_VC_SIZE_CELL = "SizeCell"
    
    var selectedToolTypeIndex = 0
    var selectedToolSizeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolViewController()
        
        setupTypeCollectionViewController()
        setupSizeCollectionViewController()
        
        // Do initial inform.
        toolPickerDelegate?.onBrushSelection(brushNO: selectedToolTypeIndex)
        toolPickerDelegate?.onSizeSelection(sizeNO: selectedToolSizeIndex)
        
    }
    
    // MARK: - Encapsulation for setting up
    
    private func setupToolViewController() {
        
        view.backgroundColor = UIColor.white
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        title.text = "Tools"
        view.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        title.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        
    }
    
    private func setupTypeCollectionViewController() {
        
        let typeCVCHeader = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        typeCVCHeader.text = "Brushes"
        view.addSubview(typeCVCHeader)
        
        typeCVCHeader.translatesAutoresizingMaskIntoConstraints = false
        typeCVCHeader.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        typeCVCHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsetsTypeCollectionViewController
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.scrollDirection = .horizontal
        typeCollectionView = UICollectionView(frame: CGRect(x: ((view.frame.size.width-300)/2) - 20, y: 100, width: 170, height: 80), collectionViewLayout: layout)
        
        typeCollectionView?.backgroundColor = UIColor.white//UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        
        typeCollectionView?.register(ToolBrushCollectionViewCell.self, forCellWithReuseIdentifier: TYPE_VC_TYPE_CELL)
        
        typeCollectionView?.delegate = self
        typeCollectionView?.dataSource = self
        view.addSubview(typeCollectionView!)
        
    }
    
    private func setupSizeCollectionViewController() {
        
        let sizeCVCHeader = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        sizeCVCHeader.text = "Sizes"
        view.addSubview(sizeCVCHeader)
        
        sizeCVCHeader.translatesAutoresizingMaskIntoConstraints = false
        sizeCVCHeader.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        sizeCVCHeader.topAnchor.constraint(equalTo: typeCollectionView!.bottomAnchor, constant: 30).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsetsSizeCollectionViewController
        layout.itemSize = CGSize(width: 60, height: 60)
        sizeCollectionView = UICollectionView(frame: CGRect(x: ((view.frame.size.width-300)/2)-10, y: 240, width: 300, height: 200), collectionViewLayout: layout)
        
        sizeCollectionView?.backgroundColor = UIColor.white //UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        sizeCollectionView?.layer.cornerRadius = 2.5
        sizeCollectionView?.layer.masksToBounds = true
        
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
            
            // Inform delegate about selection.
            toolPickerDelegate?.onBrushSelection(brushNO: selectedToolTypeIndex)
            
        }
        
        else {
            
            let oldIndexPath = IndexPath(row: selectedToolSizeIndex, section: 0)
            let oldCell = collectionView.cellForItem(at: oldIndexPath)
            applyDeselectVisualsToCell(cell: oldCell)
            selectedToolSizeIndex = indexPath.row
            
            // Inform delegate about selection.
            toolPickerDelegate?.onSizeSelection(sizeNO: selectedToolSizeIndex)
            
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
            let typeCell = collectionView.dequeueReusableCell(withReuseIdentifier: TYPE_VC_TYPE_CELL, for: indexPath) as? ToolBrushCollectionViewCell
            if indexPath.row == selectedToolTypeIndex {
                applySelectedVisualsToCell(cell: typeCell)
            }
            else {
                applyDeselectVisualsToCell(cell: typeCell)
            }
            typeCell!.backgroundColor = UIColor.white
            return typeCell!
        }
        
        let sizeCell = collectionView.dequeueReusableCell(withReuseIdentifier: SIZE_VC_SIZE_CELL, for: indexPath) as? ToolSizeCollectionViewCell
        if indexPath.row == selectedToolSizeIndex {
            applySelectedVisualsToCell(cell: sizeCell)
        }
        else {
            applyDeselectVisualsToCell(cell: sizeCell)
        }
        sizeCell?.updateToolSize(toolSize: indexPath.row+1)
        //sizeCell!.backgroundColor = UIColor.white
        return sizeCell!
        
    }
    
    // MARK: - Implement UICollectionViewDelegateFlowLayout
    
    private let sectionInsetsTypeCollectionViewController = UIEdgeInsets(
        top: 5.0,
        left: 10.0,
        bottom: 5.0,
        right: 10.0)
    private let sectionInsetsSizeCollectionViewController = UIEdgeInsets(
        top: 10.0,
        left: 10.0,
        bottom: 10.0,
        right: 10.0)
    
    private let itemsPerRowTypeVC: CGFloat = 2
    private let itemsPerRowSizeVC: CGFloat = 1
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == typeCollectionView {
            let paddingSpace = sectionInsetsTypeCollectionViewController.left * (itemsPerRowTypeVC + 1)
            let availableWidth = collectionView.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRowTypeVC
            return CGSize(width: widthPerItem, height: collectionView.frame.size.height-5)
        }
        
        let paddingSpace = sectionInsetsSizeCollectionViewController.left * (itemsPerRowSizeVC + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRowSizeVC
        return CGSize(width: widthPerItem, height: 60)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == typeCollectionView {
            return sectionInsetsTypeCollectionViewController
        }
        return sectionInsetsSizeCollectionViewController
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == typeCollectionView {
            return sectionInsetsTypeCollectionViewController.bottom
        }
        return sectionInsetsSizeCollectionViewController.bottom
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
