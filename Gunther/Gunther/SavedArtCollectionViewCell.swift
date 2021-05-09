//
//  SavedArtCollectionViewCell.swift
//  Gunther
//
//  Created by user184453 on 5/3/21.
//

import UIKit

class SavedArtCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.backgroundColor = UIColor.white // Background should be that MS Paint color
        self.contentView.layer.cornerRadius = 2.5
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5
        
        label = UILabel(frame: CGRect(x: 0, y: self.bounds.size.height-10, width: self.bounds.size.width, height: 40))
        self.addSubview(label!)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
