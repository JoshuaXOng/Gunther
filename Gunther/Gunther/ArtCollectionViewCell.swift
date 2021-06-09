//
//  SavedArtCollectionViewCell.swift
//  Gunther
//
//  Created by user184453 on 5/3/21.
//

import UIKit

/*
 * Extends UICollectionViewCell, and provides a common looking collection view cell for displaying
 * art images.
 */
class ArtCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel?
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.backgroundColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        self.contentView.layer.cornerRadius = 5
        
        setupLabel()
        setupImageView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 20))
        contentView.addSubview(label!)
        
        label!.translatesAutoresizingMaskIntoConstraints = false
        label!.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        label!.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 3).isActive = true
    
    }
    
    private func setupImageView() {
        
        imageView = UIImageView(frame: CGRect(x: 15, y: 15, width: contentView.bounds.width-30, height: contentView.bounds.height-30))
        imageView!.contentMode = UIView.ContentMode.scaleAspectFit
        imageView!.layer.shadowColor = UIColor.black.cgColor
        imageView!.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        imageView!.layer.shadowRadius = 2
        imageView!.layer.shadowOpacity = 0.5
        contentView.addSubview(imageView!)
        
        /*
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        imageView!.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        imageView!.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        imageView!.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        imageView!.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15).isActive = true
        */
        
    }
    
}
