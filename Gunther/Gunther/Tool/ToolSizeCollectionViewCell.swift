//
//  ToolBrushCollectionViewCell.swift
//  Gunther
//
//  Created by user184453 on 5/11/21.
//

import UIKit

class ToolSizeCollectionViewCell: UICollectionViewCell {
 
    var label: UILabel? // Add CGRect as the line
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.backgroundColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        self.contentView.layer.cornerRadius = 2.5
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 40))
        label!.text = "T"
        self.contentView.addSubview(label!)
        label!.translatesAutoresizingMaskIntoConstraints = false
        label!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        label!.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3).isActive = true
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: self.frame.size.height))
        imageView?.backgroundColor = UIColor.black
        self.contentView.addSubview(imageView!)
        imageView?.center = self.center
        /*
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        imageView!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        imageView!.leftAnchor.constraint(equalTo: label!.rightAnchor, constant: 3).isActive = true
        imageView!.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        */
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
