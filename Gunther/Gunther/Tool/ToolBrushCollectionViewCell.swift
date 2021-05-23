//
//  ToolSizeCollectionViewCell.swift
//  Gunther
//
//  Created by user184453 on 5/11/21.
//

import UIKit

class ToolBrushCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.contentView.layer.cornerRadius = 2.5
        self.contentView.layer.masksToBounds = true
        
        setupImageView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Encapsulation for setting up image view
    
    private func setupImageView() {
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        imageView?.backgroundColor = UIColor.black
        self.contentView.addSubview(imageView!)
        
        // Constraints.
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        imageView!.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView!.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView!.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView!.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
    }
    
}
