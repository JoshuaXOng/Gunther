//
//  ToolPickerViewController.swift
//  Gunther
//
//  Created by user184453 on 5/10/21.
//

import UIKit

class ToolPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var toolPickerDelegate: ToolPickerDelegate?
    
    //var typeCollectionView: UICollectionView?
    var sizeCollectionView: UICollectionView?
    
    //let TYPE_VC_TYPE_CELL = "TypeCell"
    let SIZE_VC_SIZE_CELL = "SizeCell"
    
    //var selectedToolTypeIndex = 0
    var selectedToolSizeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToolViewController()
        
        //setupTypeCollectionViewController()
        setupSizeCollectionViewController()
        
        // Do initial inform.
        //toolPickerDelegate?.onBrushSelection(brushNO: selectedToolTypeIndex)
        toolPickerDelegate?.onSizeSelection(sizeNO: selectedToolSizeIndex)
        
    }
    
    // MARK: - View setup
    
    private func setupToolViewController() {
        
        view.backgroundColor = UIColor.systemBackground
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        title.text = "Tool Sizes"
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        view.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        title.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
        
        let cancelButtonAction = UIAction() { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 20), primaryAction: cancelButtonAction)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor(red: 0.48, green: 0.72, blue: 0.51, alpha: 1), for: .normal)
        cancelButton.setTitleColor(UIColor(red: 0.8, green: 0.92, blue: 0.8, alpha: 1), for: .highlighted)
        view.addSubview(cancelButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 18).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18).isActive = true
        
    }
    
    /*
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
    */
    
    private func setupSizeCollectionViewController() {
        
        // Size collection view header.
        //let sizeCVCHeader = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        //sizeCVCHeader.text = "Sizes"
        //view.addSubview(sizeCVCHeader)
        
        //sizeCVCHeader.translatesAutoresizingMaskIntoConstraints = false
        //sizeCVCHeader.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        //sizeCVCHeader.topAnchor.constraint(equalTo: typeCollectionView!.bottomAnchor, constant: 30).isActive = true
        
        // Size collection view.
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsetsSizeCollectionViewController
        layout.itemSize = CGSize(width: 1, height: 1)
        sizeCollectionView = UICollectionView(frame: CGRect(x: 1, y: 1, width: 1, height: 1), collectionViewLayout: layout)
        
        sizeCollectionView?.backgroundColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        sizeCollectionView?.layer.cornerRadius = 2.5
        sizeCollectionView?.layer.masksToBounds = true
        
        sizeCollectionView?.register(ToolSizeCollectionViewCell.self, forCellWithReuseIdentifier: SIZE_VC_SIZE_CELL)
        sizeCollectionView?.delegate = self
        sizeCollectionView?.dataSource = self
        
        view.addSubview(sizeCollectionView!)
        
        sizeCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        sizeCollectionView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        sizeCollectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        sizeCollectionView?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        sizeCollectionView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true

    }
    
    // MARK: - Utils for cell visuals
    
    func applySelectedVisualsToCell(cell: UICollectionViewCell?) {
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor(red: 0.3, green: 0.4, blue: 0.3, alpha: 1).cgColor
    }
    
    func applyDeselectVisualsToCell(cell: UICollectionViewCell?) {
        cell?.layer.borderWidth = 0
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*
        if collectionView == typeCollectionView {
            
            let oldIndexPath = IndexPath(row: selectedToolTypeIndex, section: 0)
            let oldCell = collectionView.cellForItem(at: oldIndexPath)
            applyDeselectVisualsToCell(cell: oldCell)
            selectedToolTypeIndex = indexPath.row
            
            // Inform delegate about selection.
            toolPickerDelegate?.onBrushSelection(brushNO: selectedToolTypeIndex)
            
        }*/
        
        //else {
            
        let oldIndexPath = IndexPath(row: selectedToolSizeIndex, section: 0)
        let oldCell = collectionView.cellForItem(at: oldIndexPath)
        applyDeselectVisualsToCell(cell: oldCell)
        
        // Inform delegate about selection.
        selectedToolSizeIndex = indexPath.row
        toolPickerDelegate?.onSizeSelection(sizeNO: selectedToolSizeIndex)
            
        //}
        
        let newCell = collectionView.cellForItem(at: indexPath)
        applySelectedVisualsToCell(cell: newCell)
        
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
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*if collectionView == typeCollectionView {
            return 2
        }*/
        //else {
        return 8
        //}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /*if collectionView == typeCollectionView {
            let typeCell = collectionView.dequeueReusableCell(withReuseIdentifier: TYPE_VC_TYPE_CELL, for: indexPath) as? ToolBrushCollectionViewCell
            if indexPath.row == selectedToolTypeIndex {
                applySelectedVisualsToCell(cell: typeCell)
            }
            else {
                applyDeselectVisualsToCell(cell: typeCell)
            }
            typeCell!.backgroundColor = UIColor.white
            return typeCell!
        }*/
        
        let sizeCell = collectionView.dequeueReusableCell(withReuseIdentifier: SIZE_VC_SIZE_CELL, for: indexPath) as? ToolSizeCollectionViewCell
        if indexPath.row == selectedToolSizeIndex {
            applySelectedVisualsToCell(cell: sizeCell)
        }
        else {
            applyDeselectVisualsToCell(cell: sizeCell)
        }
        sizeCell?.updateToolSize(toolSize: indexPath.row+1)
        return sizeCell!
        
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    /*private let sectionInsetsTypeCollectionViewController = UIEdgeInsets(
        top: 5.0,
        left: 10.0,
        bottom: 5.0,
        right: 10.0)*/
    private let sectionInsetsSizeCollectionViewController = UIEdgeInsets(
        top: 10.0,
        left: 10.0,
        bottom: 10.0,
        right: 10.0)
    
    //private let itemsPerRowTypeVC: CGFloat = 2
    private let itemsPerRowSizeVC: CGFloat = 1
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        /*if collectionView == typeCollectionView {
            let paddingSpace = sectionInsetsTypeCollectionViewController.left * (itemsPerRowTypeVC + 1)
            let availableWidth = collectionView.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRowTypeVC
            return CGSize(width: widthPerItem, height: collectionView.frame.size.height-5)
        }*/
        
        let paddingSpace = sectionInsetsSizeCollectionViewController.left * (itemsPerRowSizeVC + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRowSizeVC
        return CGSize(width: widthPerItem, height: 60)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        /*if collectionView == typeCollectionView {
            return sectionInsetsTypeCollectionViewController
        }*/
        return sectionInsetsSizeCollectionViewController
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        /*if collectionView == typeCollectionView {
            return sectionInsetsTypeCollectionViewController.bottom
        }*/
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
