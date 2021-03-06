//
//  CommunityCollectionViewCell.swift
//  Gunther
//
//  Created by user184453 on 5/13/21.
//

import UIKit

/*
 * A custom collection view cell for displaying category cells.
 */
class CommunityCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel?
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1).cgColor
        
        contentView.layer.cornerRadius = 2.5
        
        setupLabel()
        setupImageView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 20))
        addSubview(label!)
    
        label!.translatesAutoresizingMaskIntoConstraints = false
        label!.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        label!.topAnchor.constraint(equalTo: bottomAnchor, constant: 3).isActive = true
        label!.text = "Test :]"
        
    }
    
    private func setupImageView() {
        
        // Setup imageView.
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height))
        imageView!.contentMode = UIView.ContentMode.scaleToFill
        
        imageView?.layer.shadowColor = UIColor.black.cgColor
        imageView?.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        imageView?.layer.shadowRadius = 2
        imageView?.layer.shadowOpacity = 0.5
        imageView?.layer.masksToBounds = false
        
        contentView.addSubview(imageView!)
        
        /*
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        imageView!.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView!.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView!.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        */
 
    }
    
}
