//
//  ToolBrushCollectionViewCell.swift
//  Gunther
//
//  Created by user184453 on 5/11/21.
//

import UIKit

class ToolSizeCollectionViewCell: UICollectionViewCell {
 
    private var label: UILabel? // Add CGRect as the line
    private var imageView: UIImageView?
    private var MAX_TOOL_SIZE: Int = 11
    private var toolSize: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        //self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 2.5
        self.contentView.layer.masksToBounds = true
               
        //self.layer.shadowColor = UIColor.black.cgColor
        //self.layer.shadowOpacity = 0.5
        //self.layer.shadowOffset = .zero
        //self.layer.shadowRadius = 2
        
        setupLabel()
        setupImageView()
        
        //updateToolSize(toolSize: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getToolSize() -> Int {
        return toolSize
    }
    
    // MARK: - Encapsulation for setting up components of cell
    
    private func setupLabel() {
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 40))
        label!.text = "T"
        self.contentView.addSubview(label!)
        
        // Constraints.
        label!.translatesAutoresizingMaskIntoConstraints = false
        label!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        label!.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        
    }
    
    private func setupImageView() {
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        imageView?.backgroundColor = UIColor.black
        self.contentView.addSubview(imageView!)
        
        // Constraints.
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        setupImageViewConstraintsMinusTB()
        //updateIVConstraints()

    }
    
    private func setupImageViewConstraintsMinusTB() {
        imageView!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        imageView!.leftAnchor.constraint(equalTo: label!.rightAnchor, constant: 12).isActive = true
        imageView!.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
    }
    
    // MARK: - Utils for managing the relative height of the imageView
    
    private func computeIVSpacing() -> CGFloat {
        let cellHeight = frame.height
        let totalSpacing = cellHeight-(CGFloat(toolSize)/CGFloat(MAX_TOOL_SIZE))*cellHeight
        return totalSpacing
    }
    
    private func updateIVConstraints() {
        
        let spacing = computeIVSpacing()
        let halfSpacing = spacing/2
        
        let constraints = imageView!.constraints
        imageView!.removeConstraints(constraints)
        setupImageViewConstraintsMinusTB()
        imageView!.topAnchor.constraint(equalTo: self.topAnchor, constant: halfSpacing).isActive = true
        imageView!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -halfSpacing).isActive = true
    
    }
    
    public func updateToolSize(toolSize: Int) {
        self.toolSize = min(toolSize, MAX_TOOL_SIZE)
        label?.text = String(toolSize)
        updateIVConstraints()
    }
    
}
