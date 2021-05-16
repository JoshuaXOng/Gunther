//
//  CommunityCollectionViewCell.swift
//  Gunther
//
//  Created by user184453 on 5/13/21.
//

import UIKit

class CommunityCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel?
    var imageView: UIImageView?
    var reused = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1).cgColor
        
        contentView.layer.cornerRadius = 2.5
        //contentView.layer.masksToBounds = true
        /*contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOpacity = 0.5*/
        
        // Setup imageView.
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        imageView!.contentMode = UIView.ContentMode.scaleToFill
        if !reused {
            contentView.addSubview(imageView!)
        }
        
        imageView?.layer.shadowColor = UIColor.black.cgColor
        imageView?.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        imageView?.layer.shadowRadius = 2
        imageView?.layer.shadowOpacity = 0.5
        imageView?.layer.masksToBounds = false
        
        // Setup label.
        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 20))
        if !reused {
            addSubview(label!)
        }
        label!.translatesAutoresizingMaskIntoConstraints = false
        label!.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 3).isActive = true
        label!.topAnchor.constraint(equalTo: bottomAnchor, constant: 3).isActive = true
        label?.text = "TEST"
        
        reused = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
