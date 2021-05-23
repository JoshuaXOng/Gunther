//
//  Art.swift
//  Gunther
//
//  Created by user184453 on 4/29/21.
//

import UIKit

class SavedArt: NSObject, Codable {
    
    var id: String?
    var name: String?
    var source: String? 
    var width: String?
    var height: String?
    var pixelSize: String?
    
    override init() {
        super.init()
    }
    
    init(name: String, width: String, height: String, pixelSize: String) {
        super.init()
        self.id = UUID().uuidString
        self.name = name
        self.source = UUID().uuidString+".png"
        self.width = width
        self.height = height
        self.pixelSize = pixelSize
    }
    
    func copy_() -> SavedArt {
        let savedArtCopy = SavedArt()
        savedArtCopy.id = UUID().uuidString
        savedArtCopy.name = self.name
        savedArtCopy.source = UUID().uuidString+".png"
        savedArtCopy.width = self.width
        savedArtCopy.height = self.height
        savedArtCopy.pixelSize = self.pixelSize
        return savedArtCopy
    }
    
}
