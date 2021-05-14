//
//  SavedArtCollectionViewCell.swift
//  Gunther
//
//  Created by user184453 on 5/3/21.
//

import UIKit

class ArtCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel?
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.backgroundColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        self.contentView.layer.cornerRadius = 5
        
        imageView = UIImageView(frame: CGRect(x: 15, y: 15, width: self.bounds.size.width-30, height: self.bounds.size.height-30))
        imageView!.contentMode = UIView.ContentMode.scaleAspectFit
        imageView!.layer.shadowColor = UIColor.black.cgColor
        imageView!.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        imageView!.layer.shadowRadius = 2
        imageView!.layer.shadowOpacity = 0.5
        self.contentView.addSubview(imageView!)
        
        label = UILabel(frame: CGRect(x: 0, y: self.bounds.size.height-8, width: self.bounds.size.width, height: 40))
        self.contentView.addSubview(label!)
        label!.translatesAutoresizingMaskIntoConstraints = false
        label!.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        label!.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 3).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
