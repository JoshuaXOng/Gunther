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
