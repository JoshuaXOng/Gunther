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
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.backgroundColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        self.contentView.layer.cornerRadius = 2.5
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        imageView!.contentMode = UIView.ContentMode.scaleToFill
        self.contentView.addSubview(imageView!)
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 20))
        self.contentView.addSubview(label!)
        label!.translatesAutoresizingMaskIntoConstraints = false
        label!.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3).isActive = true
        label!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        label?.text = "TEST"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
